#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;仅适用于 phpStudy 的非服务模式！

;Apache 根目录
APACHE_DIC := "F:\phpStudy\Apache"
CONF_PATH = %APACHE_DIC%\conf\vhosts.conf
HTTPD_PATH = %APACHE_DIC%\bin\httpd.exe
newPath = %1% ;%1% 代表命令行输入的第一个参数

;结束 Apache
Process, Close, httpd.exe

;读入并修改配置文件
FileRead, conf, %CONF_PATH%
conf := RegExReplace(conf, "DocumentRoot\s+"".*""", Format("DocumentRoot ""{1}""",newPath))
FileDelete %CONF_PATH%
FileAppend, %conf%, %CONF_PATH%

;启动 Apache
Run %HTTPD_PATH%,,Hide

TrayTip,, 网站根目录已切换至 %1%
Sleep 10000