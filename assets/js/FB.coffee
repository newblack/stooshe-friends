$.fn.extend
	fb_perms: (callback) ->
		this.each (element) ->
			$(this).click ->
				FB.login (res) ->
					if res.authResponse
						callback.success()
					else
						callback.fail()
				,{scope: $(this).data('perms')}
	

	fb_api: (lookup, callback) ->
		FB.api lookup, (res) ->
			callback(res)
			
	fb_fql: (query, callback) ->
		FB.api
			method: 'fql.query',
			query: query
		, (res) ->
			callback(res)
			
	fb_share: (message, callback) ->
		FB.ui
			method: 'feed'
			name: message.name
			link: message.url
			picture: message.pic
			#caption: 'Reference Documentation'
			description: message.msg
			message: message.msg
		,(res) ->
			if res and res.post_id
				callback.success()
			else
				callback.fail()