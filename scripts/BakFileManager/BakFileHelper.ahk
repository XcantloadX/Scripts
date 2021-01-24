#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


switch A_Args[1]
{
	case "-open":
		CheckParam()
		RunUsingDefault(A_Args[2])
		return
	case "-restore":
		CheckParam()
		Restore(A_Args[2])
		return
	case "-backup":
		CheckParam()
		Backup(A_Args[2])
		return
	case "-install":
		Install()
		return
	case "-uninstall":
		Uninstall()
		return
	default:
		RegRead, outVar, HKEY_CLASSES_ROOT\.bak
		If(outVar != "bakfile")
		{
			MsgBox, 36, 提示, 是否安装？`n（将会重启 explorer.exe。安装后请勿移动本程序！）
			IfMsgBox Yes
				Install()
			Else
				Exit
		}
		Else
			CheckParam()
}

CheckParam()
{
	if(A_Args.Length() < 2)
	{
		MsgBox, 16, 错误, 参数不足！
		Exit
	}
}

;使用默认程序运行
RunUsingDefault(filepath)
{
	;获取后缀
	; XXX.mp3.bak
	posA := InStr(filepath, ".", false, 0) ;.bak 的 .
	posB := InStr(filepath, ".", false, 1) ;.mp3 的 .
	type := SubStr(filepath, posB, StrLen(filepath) - posA + 1)
	if(posA = 0 or posA = posB)
	{
		MsgBox, 16, 错误, 不是 .bak 文件！
		return
	}
	
	
	;读取默认程序
	RegRead, outVar, HKEY_CLASSES_ROOT\%type%
	RegRead, outVar, HKEY_CLASSES_ROOT\%outVar%\shell\open\command
	if ErrorLevel = 1
	{
		MsgBox, 16, 错误, 未找到默认程序来打开此文件！
		return
	}
	
	;替换 %1 为 文件路径
	StringReplace, command, outVar, `%1, %filepath%
	Run %command%
}

;恢复 .bak 文件
Restore(filepath)
{
	pos := InStr(filepath, ".", false, 0)
	MsgBox, %pos%
	
	name := SubStr(filepath, 1, pos)
	FileMove, %filepath%, %name%
}

;复制并改为 .bak 文件
Backup(filepath)
{
	FileCopy, %filepath%, %filepath%.bak
}

Install()
{
	base = HKEY_CLASSES_ROOT\bakfile
	
	RegWrite, REG_SZ, HKEY_CLASSES_ROOT\.bak, , bakfile
	;图标
	RegWrite, REG_SZ, %base%\DefaultIcon, , %A_ScriptFullPath%
	
	;.bak 文件的右键菜单
	RegWrite, REG_SZ, %base%, , Backup File(.bak)
	RegWrite, REG_SZ, %base%\Shell\Open\Command, , "%A_ScriptFullPath%" -open "`%1"
	RegWrite, REG_SZ, %base%\Shell\RestoreFile, , 恢复 .bak 文件
	RegWrite, REG_SZ, %base%\Shell\RestoreFile\Command, , "%A_ScriptFullPath%" -restore "`%1"
	
	;.* 文件的右键菜单
	RegWrite, REG_SZ, HKEY_CLASSES_ROOT\*\shell\Backup, , 复制为 .bak 文件
	RegWrite, REG_SZ, HKEY_CLASSES_ROOT\*\shell\Backup\Command, , "%A_ScriptFullPath%" -backup "`%1"
	
	Process, Close, explorer.exe
	While(ErrorLevel <> 0)
		Process, Close, explorer.exe
	Run explorer.exe
	
	MsgBox, 64, 提示, 操作完成！
}

Uninstall()
{
	RegDelete, HKEY_CLASSES_ROOT\.bak
	RegDelete, HKEY_CLASSES_ROOT\bakfile
	RegDelete, HKEY_CLASSES_ROOT\*\shell\Backup
	
	MsgBox, 64, 提示, 操作完成！
}