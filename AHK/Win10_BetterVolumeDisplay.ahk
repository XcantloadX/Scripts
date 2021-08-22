#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;Dll 包装
FindWindowEx(hwndParent, hwndChildAfter, lpszClass, lpszWindow){
	Return DllCall("FindWindowEx", "Ptr", hwndParent, "Ptr", hwndChildAfter, "Str", lpszClass, "Str", lpszWindow)
}

;获取 OSD hwnd
;关掉 osd 窗口的话，下次就不会再出现，但是它也不会自动恢复
;如果要恢复，请重启 explorer.exe
FindOSD(){
	Return FindWindowEx(0, 0, "NativeHWNDHost", "")
}

Hide(){
	Global
	if(hwnd == 0)
		hwnd := FindOSD()
	WinHide, ahk_id %hwnd%
}

Show(){
	Global
	if(hwnd == 0)
		hwnd := FindOSD()
	WinShow, ahk_id %hwnd%
}

Restore(){
	Global
	if(hwnd == 0)
		hwnd := FindOSD()
	WinRestore, ahk_id %hwnd%
}

Minimize(){
	Global
	if(hwnd == 0)
		hwnd := FindOSD()
	WinMinimize, ahk_id %hwnd%
}

;----------Functions end---------------

hwnd := 0

^T::
hwnd := FindWindowEx(0, 0, "NativeHWNDHost", "")
If(hwnd == 0){
	MsgBox, , Error, Couldn't find NativeHWNDHost window,
	Return
}
Return

$Volume_Up::
Send, {Volume_Up}
SetTimer, WatchMosueClicks, 10
Return

$Volume_Down::
Send, {Volume_Down}
SetTimer, WatchMosueClicks, 10
Return

WatchMosueClicks:
x := 0
y := 0
nowHwnd := 0
;检测是不是在点 OSD
;避免调音量结果窗口关了
MouseGetPos, x, y, nowHwnd,
if(nowHwnd == hwnd){
	;OutputDebug, %nowHwnd% 
	Return
}

;获取左键状态
;如果按了一下左键，就把窗口隐藏了
if(GetKeyState("LButton", "P")){ 
	Hide()
	SetTimer, WatchMosueClicks, Off

}

Return

^R::
Reload