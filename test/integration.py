"""Full-stack checks against the local demo database; removes only this run's test accounts.
Usage: python test/integration.py [http://localhost:8081/pttk]
Requires MySQL CLI, config/database.properties, seeded schema and a running application.
"""
import concurrent.futures
import html
import http.cookiejar
import os
from pathlib import Path
import re
import subprocess
import sys
import urllib.error
import urllib.parse
import urllib.request
import uuid

BASE = (sys.argv[1] if len(sys.argv) > 1 else 'http://localhost:8081/pttk').rstrip('/')
ROOT = Path(__file__).resolve().parents[1]
MYSQL = os.environ.get('PTTK_MYSQL', 'mysql')
MANAGER_EMAIL = os.environ.get('PTTK_TEST_MANAGER_EMAIL')
MANAGER_PASSWORD = os.environ.get('PTTK_TEST_MANAGER_PASSWORD')
if not MANAGER_EMAIL or not MANAGER_PASSWORD:
    raise SystemExit('Set PTTK_TEST_MANAGER_EMAIL and PTTK_TEST_MANAGER_PASSWORD before running integration tests.')
RUN = uuid.uuid4().hex[:12]
EMAILS = [f'test-{RUN}@example.com', f'race-{RUN}@example.com']
checks = 0

def check(condition, label):
    global checks
    if not condition: raise AssertionError(label)
    checks += 1
    print('PASS:', label)

def sql(query):
    cfg = dict(line.split('=',1) for line in (ROOT/'config/database.properties').read_text(encoding='utf-8').splitlines() if line.startswith('db.'))
    url = urllib.parse.urlparse(cfg['db.url'].removeprefix('jdbc:'))
    env = os.environ.copy(); env['MYSQL_PWD'] = cfg['db.password']
    result = subprocess.run([MYSQL, '--default-character-set=utf8mb4','-N','-B','-h',url.hostname,'-P',str(url.port or 3306),'-u',cfg['db.user'],url.path[1:],'-e',query],env=env,capture_output=True)
    if result.returncode: raise RuntimeError(result.stderr.decode('utf-8',errors='replace'))
    return result.stdout.decode('utf-8').strip()

class Client:
    def __init__(self):
        self.jar = http.cookiejar.CookieJar()
        self.opener = urllib.request.build_opener(urllib.request.HTTPCookieProcessor(self.jar))
    def request(self, path, data=None):
        data = None if data is None else urllib.parse.urlencode(data).encode()
        try: response = self.opener.open(BASE+path,data,timeout=30)
        except urllib.error.HTTPError as ex: response = ex
        return response.status, response.url, response.read().decode('utf-8')
    def token(self,path):
        _,_,page = self.request(path)
        return re.search(r'name="csrf" value="([^"]+)"',page).group(1)
    def login(self,email,password):
        token = self.token('/View/SystemUser6/LoginGUI6.jsp')
        return self.request('/View/SystemUser6/LoginGUI6.jsp',dict(csrf=token,email=email,password=password))

REGISTER='/View/Customer6/MembershipRegistrationGUI6.jsp'
MANAGER='/View/Manager6/'
RANGE='fromDate=2026-09-01&toDate=2026-09-20'

def form(client,email_address,**changes):
    values=dict(csrf=client.token(REGISTER),fullName='Kiểm thử <script>alert(1)</script>',phone='0912345678',email=email_address,address='Hà Nội',password='TestPass@123',confirmPassword='TestPass@123',role='MANAGER')
    values.update(changes)
    return values

try:
    check(sql("SELECT COUNT(*) FROM information_schema.tables WHERE table_schema=DATABASE()")=='18','all 18 design tables exist')
    guest=Client()
    status,_,page=guest.request('/')
    check(status==200 and 'Siêu thị Điện máy' in page and 'SiÃ' not in page,'home and shared layout use UTF-8')
    for route in ['ManagerViewGUI6.jsp','SelectReportGUI6.jsp','FilterCustomerRevenueGUI6.jsp','CustomerRevenueReportGUI6.jsp?'+RANGE,'CustomerTransactionDetailGUI6.jsp?customerCode=KH000101&'+RANGE]:
        status,url,_=guest.request(MANAGER+route)
        check(status==200 and 'LoginGUI6.jsp?required=1' in url,'guest cannot access '+route.split('?')[0])
    _,_,page=guest.login(MANAGER_EMAIL,'incorrect')
    check('Email hoặc mật khẩu không đúng.' in page,'incorrect manager password rejected')
    manager=Client()
    status,url,page=manager.login(MANAGER_EMAIL,MANAGER_PASSWORD)
    check(status==200 and url.endswith('ManagerViewGUI6.jsp'),'manager login and redirect')
    for route in ['SelectReportGUI6.jsp','FilterCustomerRevenueGUI6.jsp']:
        check(manager.request(MANAGER+route)[0]==200,'render '+route)
    status,_,page=manager.request(MANAGER+'CustomerRevenueReportGUI6.jsp?'+RANGE)
    check(status==200 and '68.000.000' in page,'combined report total is 68 million')
    check(page.index('Phạm Thu Hà') < page.index('Nguyễn Văn An') < page.index('Trần Ngọc Linh'),'customers sorted by revenue descending')
    check('Đỗ Đức Minh' not in page,'customer without completed transactions omitted')
    check('<td class="number">7</td>' in page,'exactly seven completed transactions counted')
    check('FilterCustomerRevenueGUI6.jsp?'+html.escape(RANGE,quote=True) in page,'report back link preserves dates and returns to filter')
    for code,total,count in [('KH000101','39.000.000',3),('KH000102','23.000.000',2),('KH000103','6.000.000',2)]:
        status,_,page=manager.request(MANAGER+'CustomerTransactionDetailGUI6.jsp?customerCode='+code+'&'+RANGE)
        check(status==200 and total+' VND' in page and f'<strong>{count}</strong>' in page,'detail reconciles with report: '+code)
        check('Tại quầy' in page and 'Trực tuyến' in page,'both transaction types: '+code)
        if code=='KH000101': check('HD1004' in page and 'HD1001' in page and 'HD1007' not in page and 'DH2004' not in page,'inclusive day boundaries and pending order exclusion')
    _,_,page=manager.request(MANAGER+'CustomerRevenueReportGUI6.jsp?fromDate=2026-09-20&toDate=2026-09-20')
    check('13.000.000' in page,'same-day interval includes final second of the day')
    for query,expected in [('', 'Vui lòng chọn đầy đủ'),('?fromDate=2026-09-21&toDate=2026-09-01','Ngày bắt đầu không được lớn hơn'),('?fromDate=2026-02-30&toDate=2026-09-01','Ngày không hợp lệ')]:
        status,_,page=manager.request(MANAGER+'CustomerRevenueReportGUI6.jsp'+query)
        check(status==200 and expected in page,'invalid dates render actionable error: '+query)
    _,_,page=manager.request(MANAGER+'CustomerRevenueReportGUI6.jsp?fromDate=2025-01-01&toDate=2025-01-31')
    check('Không có dữ liệu giao dịch trong khoảng thời gian đã chọn.' in page,'empty report explained')
    check(manager.request(MANAGER+'CustomerTransactionDetailGUI6.jsp?customerCode=unknown&'+RANGE)[0]==404,'unknown customer is 404')
    data=form(guest,EMAILS[0],fullName='',phone='abc',email='invalid',password='123',confirmPassword='456')
    _,_,page=guest.request(REGISTER,data)
    check('Thông tin đăng ký không hợp lệ.' in page,'server validates all registration fields')
    _,_,page=guest.request(REGISTER,form(guest,EMAILS[0],csrf='invalid'))
    check('Phiên làm việc đã hết hạn' in page,'registration rejects invalid CSRF token')
    check(sql("SELECT COUNT(*) FROM tblSystemUser WHERE email='"+EMAILS[0]+"'")=='0','invalid submissions do not create accounts')
    status,url,page=guest.request(REGISTER,form(guest,EMAILS[0]))
    check(status==200 and 'Đăng ký thành viên thành công' in page and 'Đăng nhập ngay' in page,'successful registration and login link')
    check(sql("SELECT COUNT(*) FROM tblSystemUser u JOIN tblCustomer c ON c.userId=u.id WHERE u.email='"+EMAILS[0]+"' AND u.role='CUSTOMER' AND u.password = 'TestPass@123'")=='1','registration persists user/customer together, stores demo password, ignores submitted manager role')
    check('Đăng ký thành viên thành công' not in guest.request(REGISTER)[2],'refresh does not resubmit registration')
    _,_,page=guest.request(REGISTER,form(guest,' '+EMAILS[0].upper()+' '))
    check('Email đã được đăng ký' in page,'duplicate email rejected after normalization')
    customer=Client()
    status,url,page=customer.login(EMAILS[0],'TestPass@123')
    check(status==200 and url.endswith('CustomerMainGUI6.jsp'),'new member can log in')
    check('&lt;script&gt;alert(1)&lt;/script&gt;' in page and '<script>alert(1)</script>' not in page,'customer name escaped against stored XSS')
    for route in ['ManagerViewGUI6.jsp','CustomerRevenueReportGUI6.jsp?'+RANGE,'CustomerTransactionDetailGUI6.jsp?customerCode=KH000101&'+RANGE]:
        check(customer.request(MANAGER+route)[0]==403,'customer denied manager page: '+route.split('?')[0])
    clients=[Client(),Client()]
    forms=[form(c,EMAILS[1]) for c in clients]
    with concurrent.futures.ThreadPoolExecutor(max_workers=2) as pool:
        pages=list(pool.map(lambda args:args[0].request(REGISTER,args[1])[2],zip(clients,forms)))
    check(sum('Đăng ký thành viên thành công' in p for p in pages)==1 and sum('Email đã được đăng ký' in p for p in pages)==1,'concurrent duplicate registration creates only one membership')
    check(sql("SELECT COUNT(*) FROM tblSystemUser u JOIN tblCustomer c ON c.userId=u.id WHERE u.email='"+EMAILS[1]+"'")=='1','database confirms unique concurrent membership')
    token=manager.token(MANAGER+'ManagerViewGUI6.jsp')
    manager.request('/View/SystemUser6/LogoutGUI6.jsp',dict(csrf=token))
    check('LoginGUI6.jsp?required=1' in manager.request(MANAGER+'ManagerViewGUI6.jsp')[1],'logout invalidates manager session')
    print(f'ALL {checks} CHECKS PASSED')
finally:
    email_list=','.join("'"+email+"'" for email in EMAILS)
    sql('START TRANSACTION; DELETE c FROM tblCustomer c JOIN tblSystemUser u ON u.id=c.userId WHERE u.email IN ('+email_list+'); DELETE FROM tblSystemUser WHERE email IN ('+email_list+'); COMMIT;')
    print('Removed only temporary accounts created by this test run.')
