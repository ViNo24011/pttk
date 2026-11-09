param(
    [string]$TomcatHome = 'C:\Users\Admin\Downloads\apache-tomcat-9.0.115-windows-x64\apache-tomcat-9.0.115',
    [int]$Port = 8081,
    [switch]$SkipBuild
)
$ErrorActionPreference = 'Stop'
$projectDir = Split-Path -Parent $PSScriptRoot
if (-not $SkipBuild) { & (Join-Path $PSScriptRoot 'build.ps1') -TomcatHome $TomcatHome }
$runtimeDir = Join-Path $projectDir '.runtime\tomcat'
New-Item -ItemType Directory -Path $runtimeDir -Force | Out-Null
$appDir = Join-Path $runtimeDir 'app'
New-Item -ItemType Directory -Path $appDir -Force | Out-Null
Copy-Item -Path (Join-Path $projectDir 'build\web\*') -Destination $appDir -Recurse -Force
foreach ($folder in @('conf','logs','temp','work','webapps')) {
    New-Item -ItemType Directory -Path (Join-Path $runtimeDir $folder) -Force | Out-Null
}
Get-ChildItem -LiteralPath (Join-Path $TomcatHome 'conf') -File | Copy-Item -Destination (Join-Path $runtimeDir 'conf') -Force
$serverXml = @"
<?xml version="1.0" encoding="UTF-8"?>
<Server port="-1"><Service name="Catalina">
  <Connector port="$Port" protocol="HTTP/1.1" connectionTimeout="20000" URIEncoding="UTF-8"/>
  <Engine name="Catalina" defaultHost="localhost">
    <Host name="localhost" appBase="webapps" unpackWARs="true" autoDeploy="false" deployOnStartup="false">
      <Context path="/pttk" docBase="$($appDir.Replace('\','/'))" reloadable="false" workDir="$($runtimeDir.Replace('\','/'))/work/run-$([Guid]::NewGuid().ToString('N'))"/>
    </Host>
  </Engine>
</Service></Server>
"@
[System.IO.File]::WriteAllText((Join-Path $runtimeDir 'conf\server.xml'), $serverXml, [System.Text.UTF8Encoding]::new($false))
$javaPath = if ($env:JAVA_HOME) { Join-Path $env:JAVA_HOME 'bin\java.exe' } else { (Get-Command java.exe).Source }
Write-Output "Open http://localhost:$Port/pttk/ (Ctrl+C to stop)"
& $javaPath "-Dcatalina.home=$TomcatHome" "-Dcatalina.base=$runtimeDir" "-Djava.io.tmpdir=$runtimeDir\temp" "-Dpttk.db.config=$projectDir\config\database.properties" "-Djava.util.logging.config.file=$runtimeDir\conf\logging.properties" "-Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager" -cp "$TomcatHome\bin\bootstrap.jar;$TomcatHome\bin\tomcat-juli.jar" org.apache.catalina.startup.Bootstrap start
