param([string]$TomcatHome = 'C:\Users\Admin\Downloads\apache-tomcat-9.0.115-windows-x64\apache-tomcat-9.0.115')
$ErrorActionPreference = 'Stop'
$projectDir = Split-Path -Parent $PSScriptRoot
$javaDir = if ($env:JAVA_HOME) { Join-Path $env:JAVA_HOME 'bin' } else { Split-Path (Get-Command javac.exe).Source }
$webOutput = Join-Path $projectDir 'build\web'
$classOutput = Join-Path $webOutput 'WEB-INF\classes'
New-Item -ItemType Directory -Path $classOutput,(Join-Path $projectDir 'dist') -Force | Out-Null
Copy-Item -Path (Join-Path $projectDir 'web\*') -Destination $webOutput -Recurse -Force
$sources = @(Get-ChildItem -LiteralPath (Join-Path $projectDir 'src\java') -Filter '*.java' -Recurse | ForEach-Object FullName)
& (Join-Path $javaDir 'javac.exe') --release 21 -encoding UTF-8 -cp (Join-Path $TomcatHome 'lib\servlet-api.jar') -d $classOutput @sources
if ($LASTEXITCODE -ne 0) { throw 'Java compilation failed.' }
$warPath = Join-Path $projectDir 'dist\pttk.war'
$temporaryWar = Join-Path $projectDir ('build\pttk-' + [Guid]::NewGuid().ToString('N') + '.war')
& (Join-Path $javaDir 'jar.exe') --create --file $temporaryWar -C $webOutput .
if ($LASTEXITCODE -ne 0) { throw 'WAR packaging failed.' }
[System.IO.File]::WriteAllBytes($warPath, [System.IO.File]::ReadAllBytes($temporaryWar))
Remove-Item -LiteralPath $temporaryWar -Force
Write-Output 'Build successful: dist/pttk.war (Java 21)'
