:: Define Target Path Variables
set "SERVER_ROOT=C:\local-web-server"
set "APACHE_DIR=%SERVER_ROOT%\Apache"
:: Run Server Execution Loop
"%APACHE_DIR%\bin\httpd.exe"