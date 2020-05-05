#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#UseHook

;设置为模糊窗口匹配
SetTitleMatchMode, 2
MsgBox, % WinActive("Dreamweaver")

^H::
MsgBox, 22
return

a::
Send, a
Goto CtrlH
return

CtrlH:
;如果前台窗口是 DW
if(WinActive("Dreamweaver"))
{
	Send, ^h ;发送 Ctrl + H
}
return
