#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

url := ""
id = 0
path := "C:\"
name := "名称匹配失败.mp3"
INPUTBOX_H := 140 ;对话框高度

url := AskForUrl() ;获取 URL
;id := GetMusicID(url)
ToolTip 请稍候，正在加载...
name := GetMusicName(id) ;得到歌曲的名字
ToolTip ;关闭 ToolTip
SaveFile(id, name) ;保存

MsgBox, 下载完成

;-------------------------------------------------
AskForUrl(){
	global INPUTBOX_H, id
	clipboard := clipboard ;转换为纯文本
	url := clipboard

	;如果不是 url，请求用户输入
	;TODO: 改善 GUI，加上自动提示，等待用户复制链接并判断
	i := 0
	While(true){
		id := GetMusicId(url)
		If(id <= 0){ ;不是网易云音乐 url
			If(i = 0)
				InputBox, url, 网易云音乐下载, 请输入单曲链接(按取消关闭)：,,, INPUTBOX_H
			Else
				InputBox, url, 网易云音乐下载, 链接无效！请重新输入：,,, INPUTBOX_H
			i++
			If(ErrorLevel <> 0) ;如果取消，则退出程序
				Exit
		}
		Else ;是网易云音乐，进入下一步
			Break
	}
	Return url
}


;-------------------------------------------------
GetMusicId(url){
	;获取音乐 ID
	RegExMatch(url, "[?&]id=(\d+)", values)
	id := values1

	Return id
}

CheckUrl(url){
	id = GetMusicId(url)
	Return id <> "" && id <> 0
}



;-------------------------------------------------
GetMusicName(id){
	;读取网页源码到本地
	;直接用 WinHttp 读取网易云音乐会报错，奇怪的是其他网站不报错
	UrlDownloadToFile, http://music.163.com/song?id=%id%, C:\temp.txt
	FileEncoding, UTF-8 ;UTF8 编码，否则乱码
	FileRead, html, C:\temp.txt
	FileDelete, C:\temp.txt

	;正则匹配标题
	RegExMatch(html, "<title>(.+) - 单曲 - 网易云音乐</title>", values)
	;第一个匹配项（values0）是 "<title>XXX - XXX - 单曲 - 网易云音乐</title>"
	;第二个匹配项（values1）是 "XXX - XXX"
	name := values1 . ".mp3" ;values 是数组，valuesn 中的 n 是索引

	;替换特殊字符
	name := StrReplace(name, "\", "_")
	name := StrReplace(name, "/", "_")
	name := StrReplace(name, ":", "_")
	name := StrReplace(name, "*", "_")
	name := StrReplace(name, "?", "_")
	name := StrReplace(name, "<", "_")
	name := StrReplace(name, ">", "_")
	name := StrReplace(name, "|", "_")
	name := StrReplace(name, """", "_") ;两个连续的 " 表示一个 "

	return name
}


;-------------------------------------------------
SaveFile(id, name){
	FileSelectFolder, path,,, 选择保存位置 ;弹出保存文件提示框
	If (path = "")
		Exit

	;保存文件到本地
	UrlDownloadToFile, http://music.163.com/song/media/outer/url?id=%id%, %path%/%name%
}
