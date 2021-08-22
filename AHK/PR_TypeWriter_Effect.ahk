#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


effectPanelX := 608 ;“效果控件”面板 X 坐标
effectPanelY := 101 ;“效果控件”面板 Y 坐标
programPanelX := 1186 ;“节目”面板 X 坐标
programPanelY := 103 ;“节目”面板 Y 坐标
frameRate := 30 ;序列帧率
timePerChar := 0.1 ;每个字停留的时间，秒
framePerChar := Round(timePerChar * frameRate, 0)
text := ""

InputBox, text, 提示, 请输入字幕文本：, , 300, 150
OutputDebug, 接收到文本：%text%
If ErrorLevel
	Exit

;PS: 此段是为了强制创建一个空白关键帧，第一帧应该不显示任何字符
Click %programPanelX%, %programPanelY%
Send, 1
Send, {BackSpace}
Next()


;遍历每一个字符
Loop, % StrLen(text){
	char := SubStr(text, A_Index, 1) 
	Type(char)
	Next()
	Sleep, 500
}

ToolTip, 已完成
Sleep, 2000
ToolTip ;清除

;移动时间轴
Next()
{
	Global
	Click %effectPanelX%, %effectPanelY%
	Loop, %framePerChar%{
		Send, {Right}
		Sleep, 100
	}
}

;输入文字
Type(char)
{
	Global
	Click %programPanelX%, %programPanelY%
	Send, %char%
	Sleep, 100
}

^R::
Reload