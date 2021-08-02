// ==UserScript==
// @name         Bilibili - 不再白嫖
// @namespace    top.qwq123.scripts.BilibiliAutoLike
// @version      0.1
// @description  打开视频自动点赞
// @author       XcantloadX
// @run-at       document-end
// @icon         https://static.hdslb.com/images/favicon.ico
// @match        *://www.bilibili.com/video/*
// @require      https://cdn.bootcdn.net/ajax/libs/jquery/3.6.0/jquery.min.js
//// @require      file:///F:/GitWorkSpace/油猴/Blibili_AutoLike.js
// @license      MIT License
// ==/UserScript==

(function() {
    $(function (){
        let liked = false;
        let oldPath = "";

        //刷新检测
        window.setInterval(function(){
            if(location.pathname != oldPath){
                oldPath = location.pathname;
                window.setTimeout(doLike, 5000);
            }
        });

        function doLike(){
            let like = undefined;
            if($(".ops .like").length > 0)
                like = $(".ops .like");
            else
                return;

            if(!$(like).hasClass("on")){
                $(like).click();
                $(like).addClass("on"); //防止太卡
                liked = true;
            }
        }
    });
})();