#vars
window.friends = {}
window.content = ''

window.score = (user, score, time) ->
	unless user.id is window.user.id
		if window.friends["#{user.id}"]
			window.friends["#{user.id}"].last = time if window.friends["#{user.id}"].last < time 
			window.friends["#{user.id}"].score = window.friends["#{user.id}"].score + score
		else
			window.friends["#{user.id}"] =
				name: user.name
				score: score
				last: time

window.switch = (text) ->
	count = $('.js__count')
	count.fadeOut ->
		count.html text
		count.fadeIn()

# @codekit-prepend "FB"

$ ->
		
	$('.js__perms').fb_perms
		success: ->
			$().fb_api "/me", (user) ->
				window.user = user
				$('.message').fadeOut ->
					$('.message').html "<h2 class='secondary js__count'>Analysing your relationships</h2>"
					$('.message').fadeIn()
						
					#now go through statuses and see who has commented and liked
					$().fb_api "/me/statuses", (statuses) ->
						window.switch "importing status updates" 
						$(statuses.data).each (id, status) ->
							time = status.updated_time
							if status.likes
								$(status.likes.data).each (id, like) ->
									window.score like, 2, Date.parse time
							$(status.comments).each (id, comments) ->
								$(comments.data).each (id, comment) ->
									window.score comment.from, 4, Date.parse comment.created_time
					
						#now go through feed and see who has commented
						$().fb_api "/me/feed", (feeds) ->
							console.log feeds
							window.switch "importing feed comments"
							$(feeds.data).each (id, feed) ->
								if feed.from.id is window.user.id
									window.score(feed.from, 8, Date.parse feed.created_time)
								else
									$(feed.comments).each (id, comments) ->
										$(comments.data).each (id, comment) ->
											window.score(comment.from, 4, Date.parse comment.created_time)
							
							
							FB.api
								method: 'fql.query',
								query: "SELECT actor_id, created_time FROM stream WHERE source_id = me() LIMIT 10000"
							,(data) ->
								$(data).each (id, user) ->
									window.score(user.actor_id, 4, Date.parse user.created_time)
							
							#now go through messages
							$().fb_api "/me/threads", (messages) ->
								window.switch "importing inbox messages"
								$(messages.data).each (id, message) ->
									count = message.message_count
									time = message.messages.data[0].created_time
									$(message.senders.data).each (id, sender) ->
										$(sender).each (id, sender) ->
											window.score sender, count*2, Date.parse time
																	
								#now go through photos and see who has uploaded
								$().fb_api "/me/photos", (photos) ->
									window.switch "importing friend photo tags"
									$(photos.data).each (id, photo) ->
										window.score photo.from, 8, Date.parse photo.created_time
									i = 0
									
									$(Object.keys(window.friends)).each (id, friend) ->
										user = window.friends[friend]
										time = new Date() - new Date(user.last)
										time = Math.floor(time/(24*3600*1000))
										if time < 183
											delete window.friends[friend] 
										else
											if i < 15
												window.content = window.content + "
													<div class='profile__wrapper'>
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
												<a class='button'>Confirm</a>
	
											"
											$('.message--large').fadeIn()
									, 3000
					
		fail: -> 
			alert 'please accept the permissions to continue'
			
	$('.page').on "click", ".profile__wrapper", ->
		$this = $(this)
		$('.profile__selected').removeClass('profile__selected')
		$(this).addClass('profile__selected')
		$('.friends-name').fadeOut ->
			$('.friends-name').html $this.children('.profile__pic').attr('alt')
			$('.friends-name').fadeIn()
