@echo off
:: Force the script to run with Administrative Privileges
NET SESSION >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo [ERROR] This script requires Administrator rights!
    echo Right-click this file and choose "Run as administrator".
    pause
    exit /b
)

echo =======================================================
echo    LOCAL NATIVE SERVER STACK FILE DEPLOYER
echo =======================================================

:: Define Target Path Variables
set "SERVER_ROOT=C:\local-web-server"
set "APACHE_DIR=%SERVER_ROOT%\Apache"
set "PHP_DIR=%SERVER_ROOT%\PHP"
set "SETUP_DIR=%~dp0"

:: Step 1: Verify all 4 required local assets are present before running
if not exist "%SETUP_DIR%httpd-2.4.67-260504-Win64-VS18.zip" (
    echo [ERROR] Missing 'httpd-2.4.67-260504-Win64-VS18.zip' in this folder!
    pause
    exit /b
)
if not exist "%SETUP_DIR%php-8.5.6-Win32-vs17-x64.zip" (
    echo [ERROR] Missing 'php-8.5.6-Win32-vs17-x64.zip' in this folder!
    pause
    exit /b
)
if not exist "%SETUP_DIR%httpd.conf" (
    echo [ERROR] Missing your custom 'httpd.conf' file in this folder!
    pause
    exit /b
)
if not exist "%SETUP_DIR%php.ini" (
    echo [ERROR] Missing your custom 'php.ini' file in this folder!
    pause
    exit /b
)
phpphp
echo [1/5] Creating Directory Structure at %SERVER_ROOT%...
if not exist "%SERVER_ROOT%" mkdir "%SERVER_ROOT%"
if not exist "%APACHE_DIR%" mkdir "%APACHE_DIR%"
if not exist "%PHP_DIR%" mkdir "%PHP_DIR%"

echo [2/5] Extracting Local Pre-Downloaded Archives...
echo Extracting Apache 2.4.67...
powershell -Command "Expand-Archive -Path '%SETUP_DIR%httpd-2.4.67-260504-Win64-VS18.zip' -DestinationPath '%SERVER_ROOT%\temp_apache' -Force"
xcopy "%SERVER_ROOT%\temp_apache\Apache24\*" "%APACHE_DIR%\" /E /I /Y >nul
rmdir /S /Q "%SERVER_ROOT%\temp_apache"

echo Extracting PHP 8.5.6...
powershell -Command "Expand-Archive -Path '%SETUP_DIR%php-8.5.6-Win32-vs17-x64.zip' -DestinationPath '%PHP_DIR%' -Force"

echo Downloading Secure SSL CA Certificate Bundle...
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -UseBasicParsing -Uri 'https://curl.se' -OutFile '%PHP_DIR%\cacert.pem'"

echo [3/5] Moving Your Custom Configuration Files into Place...
:: Overwrite the default config files with your unedited, custom-built ones
copy "%SETUP_DIR%httpd.conf" "%APACHE_DIR%\conf\httpd.conf" /Y >nul
copy "%SETUP_DIR%php.ini" "%PHP_DIR%\php.ini" /Y >nul

echo [4/5] Registering System Environment Paths...
:: Clean up trailing slashes dynamically to ensure exact string matching in environment variable list
if "%PHP_DIR:~-1%"=="\" set "PHP_DIR=%PHP_DIR:~0,-1%"
powershell -Command "$m = [System.EnvironmentVariableTarget]::Machine; $current = [System.Environment]::GetEnvironmentVariable('Path', $m); if ($current -split ';' -notcontains '%PHP_DIR%') { [System.Environment]::SetEnvironmentVariable('Path', $current + ';%PHP_DIR%', $m); Write-Host 'SUCCESS: Path added smoothly.' } else { Write-Host 'NOTICE: Path already exists, skipping to avoid duplicates.' }"

echo [5/5] Deploying Replication Script ^& Cleaning Directory...
if exist "%APACHE_DIR%\htdocs\index.php" del /F /Q "%APACHE_DIR%\htdocs\index.php"
if exist "%APACHE_DIR%\htdocs\index.html" del /F /Q "%APACHE_DIR%\htdocs\index.html"

echo [6/6] Copy .bat files to desktop...

copy "%SETUP_DIR%run-local-web-server.bat" "%USERPROFILE%\Desktop\" /Y >nul
copy "%SETUP_DIR%run_jupyter.bat" "%USERPROFILE%\Desktop\" /Y >nul

:: Pull down your specific production framework file directly into htdocs [1.12]
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -UseBasicParsing -Uri 'https://raw.githubusercontent.com/LafeLabs/science-instrument/refs/heads/main/replicate-file-set.php' -OutFile '%APACHE_DIR%\htdocs\replicate-file-set.php'"

:: Navigate to the folder where the script was downloaded
cd /d "%APACHE_DIR%\htdocs"

:: Run the script using the local PHP engine
"%PHP_DIR%\php.exe" replicate-file-set.php

echo =======================================================
echo  SUCCESS! Files copied and deployed without modifications!
echo  Booting the Apache server automatically...
echo =======================================================

:: Run Server Execution Loop
"%APACHE_DIR%\bin\httpd.exe"


