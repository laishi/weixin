
joke_controller = require './controller/joke_controller'

module.exports = (route) ->
	route.text 'hello', (data, req, res, next) ->
		console.log 'hello text event'
		res.reply 'hello world'

	route.text ['help', 'h', '帮助'], (data, req, res, next) ->
		res.reply	"""
			hello 测试命令
			joke 笑话
			"""
			

	route.text ['joke', '笑话'], joke_controller.joke