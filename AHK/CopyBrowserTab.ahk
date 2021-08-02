#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;Win + C：复制当前浏览器标签页
#c::
SendInput, ^l ;定位到地址栏
Sleep 20
SendInput, ^c ;复制
SendInput, ^t ;打开新标签页
SendInput, ^l ;定位到地址栏
SendInput, ^v ;粘贴
SendInput, {Enter}