import DAO.DAO;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class ApplicationSetup implements ServletContextListener {
    @Override public void contextInitialized(ServletContextEvent event) {
        DAO.configure(event.getServletContext().getInitParameter("databaseConfig"));
    }
}
