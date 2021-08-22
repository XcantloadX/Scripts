// ==UserScript==
// @name         Bilibili - 不再白嫖
// @namespace    top.qwq123.scripts.BilibiliAutoLike
// @version      0.3
// @description  打开视频、专栏、番剧、评论、动态自动点赞
// @author       XcantloadX
// @run-at       document-end
// @icon         https://static.hdslb.com/images/favicon.ico
// @match        *://www.bilibili.com/video/*
// @match        *://t.bilibili.com/*
// @match        *://space.bilibili.com/*/favlist/*
// @match        *://www.bilibili.com/bangumi/play/*
// @match        *://www.bilibili.com/read/*
// @require      https://cdn.bootcdn.net/ajax/libs/jquery/3.6.0/jquery.min.js
// @license      MIT License
// ==/UserScript==

(function() {
    window.AutoLike = {
        //true=启用，false=禁用
        settings: {
            //视频
            video: {
                enabled: true, //是否启用视频点赞
                comment: { //评论
                    enabled: false, //是否启用评论点赞
                    subComment: false, //是否给楼中楼点赞
                    minLikeCount: 20 //评论点赞数量小于等于这个数就不会点赞
                }
            },
            //专栏
            passage: {
                enabled: true, //是否启用专栏点赞
                comment: { //评论
                    enabled: false, //是否启用评论点赞
                    subComment: false, //是否给楼中楼点赞
                    minLikeCount: 20 //评论点赞数量小于等于这个数就不会点赞
                }
            },
            //动态
            following: {
                enabled: false, //是否启用动态自动点赞
                comment: { //评论
                    enabled: false, //是否启用评论点赞
                    subComment: false, //是否给楼中楼点赞
                    minLikeCount: 20 //评论点赞数量小于等于这个数就不会点赞
                }
            },

            //番剧
            bangumi: {
                enabled: true, //是否启用番剧点赞
                comment: { //评论
                    enabled: false, //是否启用评论点赞
                    subComment: false, //是否给楼中楼点赞
                    minLikeCount: 20 //评论点赞数量小于等于这个数就不会点赞
                }
            }
        },

        init: function(){
            let url = window.location.toString();
            if(url.search("t.bilibili.com") > -1){ //动态
                if(this.settings.following.enabled)
                    this.initFollowing();
                if(this.settings.following.comment.enabled)
                    this.initComments(this.settings.following.comment);
            }
            if(url.search("www.bilibili.com/video/.+") > -1){ //视频
                if(this.settings.video.enabled)
                    $(this.initVideo);
                if(this.settings.video.comment.enabled)
                    this.initComments(this.settings.video.comment);
            }
            if(url.search("www.bilibili.com/read/.+") > -1){ //专栏
                if(this.settings.passage.enabled)
                    $(this.initPassage);
                if(this.settings.passage.comment.enabled)
                    this.initComments(this.settings.passage.comment);
            }
            if(url.search("www.bilibili.com/bangumi/play/.+") > -1){ //番剧
                if(this.settings.bangumi.enabled)
                    $(this.initBangumi);
                if(this.settings.bangumi.comment.enabled)
                    this.initComments(this.settings.bangumi.comment);
            }
        },

        //动态页面
        initFollowing: function(){
            console.log("AutoLike 已加载（动态）");
            let likes = []; //待点赞按钮
            let observer = new MutationObserver(function(changes){
                changes.forEach(function(change){
                    if(change.type != "childList")
                        return;

                    if($(change.target).hasClass("card")){ //判断是否是动态卡片
                        let likeBtn = $(change.target).find(".button-bar").find(".custom-like-icon")[0];
                        if(typeof(likeBtn) == "undefined" || $(likeBtn).hasClass("zan-hover")) //未找到按钮或已赞
                            return;
                        if(!likes.includes(likeBtn)) //避免重复添加
                            likes.push(likeBtn);
                    }
                });

            });
            observer.observe(document.body, {attributes: true, childList: true, subtree: true});
            window.setInterval(function(){
                if(likes.length > 0){
                    $(likes.shift()).click();
                    console.log("已赞");
                }
            }, 1000); //为了避免太快，采用队列的方式逐个点赞
        },

        //视频页面
        initVideo: function(){
            console.log("AutoLike 已加载（视频）");
            let liked = false;
            let oldPath = "";
    
            //跳转检测（主要是从旁边推荐点进去）
            window.setInterval(function(){
                if(location.pathname != oldPath){
                    oldPath = location.pathname;
                    window.setTimeout(doLike, 5000);
                }
            });
    
            function doLike(){
                let like;
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
        },

        //专栏
        initPassage: function(){
            console.log("AutoLike 已加载（专栏）");
            window.setTimeout(function(){
                $(".icon-like").click();
            }, 5000);
        },

        //番剧
        //视频页和番剧页点赞的 class 居然不一样
        initBangumi: function(){
            console.log("AutoLike 已加载（番剧）");
            let liked = false;
            let oldPath = "";
    
            //跳转检测（主要是从旁边推荐点进去 + 换P）
            window.setInterval(function(){
                if(location.pathname != oldPath){
                    oldPath = location.pathname;
                    window.setTimeout(doLike, 5000);
                }
            });
    
            function doLike(){
                if($(".icon-like").length <= 0)
                    return;
    
                if($(".like-info.active").length <= 0){ //若没有点赞
                    $(".icon-like").click();
                    liked = true;
                }
            }
        },

        //评论区
        initComments: function(commentSettings){
            console.log("AutoLike 已加载（评论）");
            let commentList;
            let likes = []; //待点赞按钮


            let observer = new MutationObserver(function(changes){
                changes.forEach(function(change){
                    if(change.type != "childList")
                        return;

                    if($(change.target).hasClass("comment-list")){ //评论区
                        commentList = change.target;
                        likes = $(commentList).find(".con .info .like").toArray();
                    }
                });

            });

            observer.observe(document.body, {attributes: true, childList: true, subtree: true});

            window.setInterval(function(){
                if(likes.length <= 0)
                    return;
                let like = likes.shift();
                let isSubComment = $(like).parents(".reply-box").length > 0; //是否是楼中楼
                let likeCount; //点赞数
                if($(like).children("span").text() === "")
                    likeCount = 0;
                else
                    likeCount = parseInt($(like).children("span").text());


                if($(like).hasClass("liked")) //跳过已赞
                    return;
                if(!commentSettings.subComment && isSubComment)
                    return;
                if(likeCount <= commentSettings.minLikeCount)
                    return;

                $(like).click();
                console.log("已赞");
                
            }, 300); //为了避免太快，采用队列的方式逐个点赞
        }
    };
    AutoLike.init();

    window.AL = {};
    //取消所有点赞
    window.AL.cancelAll = function(){
        $(".liked").click();
    };
})();