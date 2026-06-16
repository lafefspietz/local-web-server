![](qrcode.png)
# [local-web-server](https://github.com/lafefspietz/local-web-server)

A local web server built directly from the latest Apache and PHP builds to avoid out of date packages in existing plug and play local serves. To install, download the folder and run the .bat file in it.

To install, download and unzip the setup folder:

## [serversetup.zip](serversetup.zip)

And run the file "install-local-server.bat" as Administrator(THIS IS REQUIRED!) to install and run the server. Then to run the server again, click the .bat file copied to the desktop, called "run-local-web-server.bat" and to run Jupyter run the bat file "run-jupyter.bat".

This is currently using downloaded .zip files from [Apache Lounge](https://www.apachelounge.com/download/) and [php.net](https://www.php.net/downloads.php). 

Specifically, the PHP install file is the 64 bit "thread safe" zip called php-8.5.6-Win32-vs17-x64.zip, which is PHP 8.5.6. 

Apache is from the file  httpd-2.4.68-260610-Win64-VS18.zip, which is Apache 2.4.68.[updated to most recent June 16, 2026]

As these become out-dated, this respository will be updated with newer versions of both PHP and Apache.  If you want to fork this and keep it up to date yourself, just keep udating the .zip files and and re-installing and it should be possible to lose all connection to this initial instance and still run.  

Jupyter notebooks assume you already have that working. 

Windows firewall needs to allow apache httpd to see the world, which it should, but if XAMPP was previously installed it could need to be manually added. 



to fix the problem where a [Windows service that doesn't seem to be useful](https://learn.microsoft.com/en-us/windows-hardware/drivers/network/ip-helper) for anything seizes port 80 on reboot, run this as Administrator in the Windows Power Shell(run as administrator):

```
Set-Service -Name "iphlpsvc" -StartupType Disabled
```

To update to a newer version of apache manually without running the script after you already have it all working, download the latest Apache for win64, unzip the folder, stop the server from running, and delete ONLY the old folders "bin", "include", "lib", and "modules" and replace them with the folders from the new Apache folder you just downloaded, then re-start the server.

The folders ofr Apache version 2.4.68 can be found in [this zip file](version_updates_folders_apache_2.4.68.zip)