// Generated by CoffeeScript 1.6.1
(function(){$.fn.extend({fb_perms:function(e){return this.each(function(t){return $(this).click(function(){return FB.login(function(t){return t.authResponse?e.success():e.fail()},{scope:$(this).data("perms")})})})},fb_api:function(e,t){return FB.api(e,function(e){return t(e)})},fb_fql:function(e,t){return FB.api({method:"fql.query",query:e},function(e){return t(e)})}});window.friends={};window.content="";window.score=function(e,t,n){if(window.friends[""+e]){window.friends[""+e].last<n&&(window.friends[""+e].last=n);return window.friends[""+e].score=window.friends[""+e].score+t}};window["switch"]=function(e){var t;t=$(".js__count");return t.fadeOut(function(){t.html(e);return t.fadeIn()})};$(function(){$(".js__perms").fb_perms({success:function(){return $().fb_api("/me/friends",function(e){return $(".message").fadeOut(function(){$(".message").html("<h2 class='secondary js__count'>Analysing your friends</h2>");return $(".message").fadeIn(function(){var t;t=1;$(e.data).each(function(e,n){window["switch"]("reviewing "+t+" friends");t++;return window.friends[""+n.id]={name:n.name,score:0,last:0}});return $().fb_api("/me",function(e){var n;window.user=e;n="SELECT actor_id, created_time, type, comments, likes FROM stream WHERE source_id = me() AND type != 237 AND actor_id != '' LIMIT 10000";return $().fb_fql(n,function(n){window["switch"]("going through your feed");$(n).each(function(e,t){var n;n=t.created_time;window.score(t.actor_id,4,Date.parse(n));$(t.comments.comment_list).each(function(e,t){return window.score(t.fromid,1,Date.parse(n))});return $(t.likes).each(function(e,t){return $(t.friends).each(function(e,t){return window.score(t,1,Date.parse(n))})})});return $().fb_api("/me/threads",function(n){window["switch"]("importing inbox messages");$(n.data).each(function(e,t){var n,r;n=t.message_count;r=t.messages.data[0].created_time;return $(t.senders.data).each(function(e,t){return $(t).each(function(e,t){return window.score(t.id,n,Date.parse(r))})})});t=0;$(Object.keys(window.friends)).each(function(n,r){var s,o;e=window.friends[r];s=new Date-new Date(e.last);s=Math.floor(s/864e5);if(s<122)return delete window.friends[r];if(e.last===0)return delete window.friends[r];o="";t>14&&(o="hidden");window.content=window.content+("													<div class='profile__wrapper "+o+"'>														<img 															src='https://graph.facebook.com/"+r+"/picture?return_ssl_resources=1&type=large'															alt='"+e.name+"'															class='profile__pic'															data-id='"+r+"'														>													</div>												");return t++});return setTimeout(function(){return $(".message").fadeOut(function(){$(".message").addClass("message--large").removeClass("message").html("												<h2 class='secondary'>Choose <span class='friends-name'>a friend...</span></h2>												<div class='profile'>													"+window.content+"												</div>												<a class='button'>Confirm</a>													");return $(".message--large").fadeIn()})},6e3)})})})})})})},fail:function(){return alert("please accept the permissions to continue")}});return $(".page").on("click",".profile__wrapper",function(){var e;e=$(this);$(".profile__selected").removeClass("profile__selected");$(this).addClass("profile__selected");return $(".friends-name").fadeOut(function(){$(".friends-name").html(e.children(".profile__pic").attr("alt"));return $(".friends-name").fadeIn()})})})}).call(this);