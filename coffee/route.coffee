
module.exports = (route) ->
	route.text 'hello', (data, req, res, next) ->
		console.log 'hello text event'
		res.reply 'hello world'