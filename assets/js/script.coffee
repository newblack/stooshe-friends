#vars
window.friends = {}
window.content = ''

window.score = (user, score, time) ->
	if window.friends["#{user}"]
		window.friends["#{user}"].last = time if window.friends["#{user}"].last < time 
		window.friends["#{user}"].score = window.friends["#{user}"].score + score

window.switch = (text) ->
	count = $('.js__count')
	count.fadeOut ->
		count.html text
		count.fadeIn()

# @codekit-prepend "FB"

$ ->
		
	$('.js__perms').fb_perms
		success: ->
			$().fb_api "/me/friends", (friends) ->
				$('.message').fadeOut ->
					$('.message').html "<h2 class='secondary js__count'>Analysing your friends</h2>"
					$('.message').fadeIn ->
						window.switch "reviewing #{friends.data.length} friends"	
						$(friends.data).each (id, friend) ->
							window.friends["#{friend.id}"] = 
								name: friend.name
								score: 0
								last: 0
		
						$().fb_api "/me", (user) ->
							window.user = user
				
							query = "SELECT actor_id, created_time, type, comments, likes FROM stream WHERE source_id = me() AND type != 237 AND actor_id != '' LIMIT 10000"
							$().fb_fql query, (data) ->
								window.switch "going through your feed"
								$(data).each (id, user) ->
									time = user.created_time
									window.score(user.actor_id, 4, Date.parse time)
									$(user.comments.comment_list).each (id, user) ->
										window.score(user.fromid, 1, Date.parse time)
									$(user.likes).each (id, likes) ->
										$(likes.friends).each (id, user) ->
											window.score user, 1, Date.parse time
		
								
								#now go through messages
								$().fb_api "/me/threads", (messages) ->
									window.switch "importing inbox messages"
									$(messages.data).each (id, message) ->
										count = message.message_count
										time = message.messages.data[0].created_time
										$(message.senders.data).each (id, sender) ->
											$(sender).each (id, sender) ->
												window.score sender.id, count, Date.parse time
																		
									i = 0
									$(Object.keys(window.friends)).each (id, friend) ->
										user = window.friends[friend]
										time = new Date() - new Date(user.last)
										time = Math.floor(time/(24*3600*1000))
										if time < (30.5*4)
											delete window.friends[friend] 
										else
											if user.last is 0
												delete window.friends[friend] 
											else
												vis = ''
												if i > 14
													vis = 'hidden'
												window.content = window.content + "
													<div class='profile__wrapper #{vis}'>
														<img 
															src='https://graph.facebook.com/#{friend}/picture?return_ssl_resources=1&type=large'
															alt='#{user.name}'
															class='profile__pic'
															data-id='#{friend}'
														>
													</div>
												"
												i++
											
									setTimeout ->
										$('.message').fadeOut ->
											$('.message').addClass("message--large").removeClass('message').html "
												<h2 class='secondary'>Choose <span class='friends-name'>a friend...</span></h2>
												<div class='profile'>
													#{window.content}
												</div>
												<a class='button js__confirm'>Confirm</a>
		
											"
											$('.message--large').fadeIn()
									, 6000
						
		fail: -> 
			alert 'please accept the permissions to continue'
			
	$('.page').on "click", ".profile__wrapper", ->
		$this = $(this)
		$('.profile__selected').removeClass('profile__selected')
		$(this).addClass('profile__selected')
		$('.friends-name').fadeOut ->
			$('.friends-name').html $this.children('.profile__pic').attr('alt')
			$('.friends-name').fadeIn()


	$('.page').on "click", ".js__confirm", ->
		box = $('.message--large')
		box.fadeOut ->
			box.load 'done.html', ->
				box.fadeIn()
				
	$('.share__facebook').click ->
		$().fb_share 
			title: "Don't let it slip"
			msg: "Have you been a bad friend? Don't let it slip, use Stooshe's Facebook app to find the friends you've lost touch with"
			url: "https://www.facebook.com/stooshe/app_124292764425515"
			pic: "https://stooshe.newblack.me/assets/img/share-icon.png"
			
			
			
			
			