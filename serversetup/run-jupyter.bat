SET "INSTALL_DIR=%LOCALAPPDATA%\\Miniforge3"
call "%INSTALL_DIR%\\Scripts\\activate.bat"
cd /d "c:\local-web-server\Apache\htdocs"
call jupyter notebook --notebook-dir="C:\local-web-server\Apache\htdocs"