// Generated by CoffeeScript 1.6.1
(function(){$.fn.extend({fb_perms:function(e){return this.each(function(t){return $(this).click(function(){return FB.login(function(t){return t.authResponse?e.success():e.fail()},{scope:$(this).data("perms")})})})},fb_api:function(e,t){return FB.api(e,function(e){return t(e)})},fb_fql:function(e,t){return FB.api({method:"fql.query",query:e},function(e){return t(e)})}});window.friends={};window.content="";window.score=function(e,t,n){if(e.id!==window.user.id){if(window.friends[""+e.id]){window.friends[""+e.id].last<n&&(window.friends[""+e.id].last=n);return window.friends[""+e.id].score=window.friends[""+e.id].score+t}return window.friends[""+e.id]={name:e.name,score:t,last:n}}};window["switch"]=function(e){var t;t=$(".js__count");return t.fadeOut(function(){t.html(e);return t.fadeIn()})};$(function(){$(".js__perms").fb_perms({success:function(){return $().fb_api("/me",function(e){window.user=e;return $(".message").fadeOut(function(){$(".message").html("<h2 class='secondary js__count'>Analysing your relationships</h2>");$(".message").fadeIn();return $().fb_api("/me/statuses",function(t){window["switch"]("importing status updates");$(t.data).each(function(e,t){var n;n=t.updated_time;t.likes&&$(t.likes.data).each(function(e,t){return window.score(t,2,Date.parse(n))});return $(t.comments).each(function(e,t){return $(t.data).each(function(e,t){return window.score(t.from,4,Date.parse(t.created_time))})})});return $().fb_api("/me/feed",function(t){console.log(t);window["switch"]("importing feed comments");$(t.data).each(function(e,t){return t.from.id===window.user.id?window.score(t.from,8,Date.parse(t.created_time)):$(t.comments).each(function(e,t){return $(t.data).each(function(e,t){return window.score(t.from,4,Date.parse(t.created_time))})})});FB.api({method:"fql.query",query:"SELECT actor_id, created_time FROM stream WHERE source_id = me() LIMIT 10000"},function(e){return $(e).each(function(e,t){return window.score(t.actor_id,4,Date.parse(t.created_time))})});return $().fb_api("/me/threads",function(t){window["switch"]("importing inbox messages");$(t.data).each(function(e,t){var n,r;n=t.message_count;r=t.messages.data[0].created_time;return $(t.senders.data).each(function(e,t){return $(t).each(function(e,t){return window.score(t,n*2,Date.parse(r))})})});return $().fb_api("/me/photos",function(t){var n;window["switch"]("importing friend photo tags");$(t.data).each(function(e,t){return window.score(t.from,8,Date.parse(t.created_time))});n=0;$(Object.keys(window.friends)).each(function(t,r){var s;e=window.friends[r];s=new Date-new Date(e.last);s=Math.floor(s/864e5);if(s<183)return delete window.friends[r];if(n<15){window.content=window.content+("													<div class='profile__wrapper'>														<img 															src='https://graph.facebook.com/"+r+"/picture?return_ssl_resources=1&type=large'															alt='"+e.name+"'															class='profile__pic'															data-id='"+r+"'														>													</div>												");return n++}});return setTimeout(function(){return $(".message").fadeOut(function(){$(".message").addClass("message--large").removeClass("message").html("												<h2 class='secondary'>Choose <span class='friends-name'>a friend...</span></h2>												<div class='profile'>													"+window.content+"												</div>												<a class='button'>Confirm</a>												");return $(".message--large").fadeIn()})},3e3)})})})})})})},fail:function(){return alert("please accept the permissions to continue")}});return $(".page").on("click",".profile__wrapper",function(){var e;e=$(this);$(".profile__selected").removeClass("profile__selected");$(this).addClass("profile__selected");return $(".friends-name").fadeOut(function(){$(".friends-name").html(e.children(".profile__pic").attr("alt"));return $(".friends-name").fadeIn()})})})}).call(this);