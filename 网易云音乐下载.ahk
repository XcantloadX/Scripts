#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

url := ""
id = 0
path := "C:\"
name := "名称匹配失败.mp3"

GoSub GetMusicUrl ;获取 URL
GoSub GetMusicId ;获取 ID
GoSub GetMusicName ;得到歌曲的名字
GoSub SaveFile ;保存

ToolTip, 下载完成
Sleep, 700 ;让 ToolTip 显示一会

return

;-------------------------------------------------
GetMusicUrl:
ToolTip, 请复制链接
ClipWait ;等待用户复制文本
clipboard := clipboard ;转换为纯文本
url := clipboard

;如果不是 url，请求用户输入
if(InStr(clipboard, "music.163.com") <= 0)
{
	InputBox, url, 网易云音乐下载, 请输入音乐链接：,,, 150 ;150 对话框是高度
	if(ErrorLevel <> 0) ;如果取消，则退出程序
		Exit
}

return


;-------------------------------------------------
GetMusicId:
;获取音乐 ID

RegExMatch(url, "[?&]id=(\d+)", values)
id := values1
return


;-------------------------------------------------
GetMusicName:
;读取网页源码到本地
;直接用 WinHttp 读取网易云音乐会报错，奇怪的是其他网站不报错
UrlDownloadToFile, http://music.163.com/song?id=%id%, C:\temp.txt 
FileEncoding, UTF-8 ;UTF8 编码，否则乱码
FileRead, html, C:\temp.txt
FileDelete, C:\temp.txt

;正则匹配标题
RegExMatch(html, "<title>(.+) - 单曲 - 网易云音乐</title>", values)
;第一个匹配项（value0）是 "<title>XXX - XXX - 单曲 - 网易云音乐</title>"
;第二个匹配项（value1）是 "XXX - XXX"
name := values1 . ".mp3" ;values 是数组，valuesn 中的 n 是索引

;替换特定字符
name := StrReplace(name, "\", "_")
name := StrReplace(name, "/", "_")
name := StrReplace(name, ":", "_")
name := StrReplace(name, "*", "_")
name := StrReplace(name, "?", "_")
name := StrReplace(name, "<", "_")
name := StrReplace(name, ">", "_")
name := StrReplace(name, "|", "_")
name := StrReplace(name, """", "_") ;两个连续的 " 表示一个 "
return


;-------------------------------------------------
SaveFile:
FileSelectFolder, path,,, 选择保存位置 ;弹出保存文件提示框
if (path = "")
	Exit

;保存文件到本地
UrlDownloadToFile, http://music.163.com/song/media/outer/url?id=%id%, %path%/%name%
return
