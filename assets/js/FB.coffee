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