
joke_controller = require './controller/joke_controller'
ceshi_controller = require './controller/ceshi_controller'

module.exports = (route) ->
	route.text 'hello', (data, req, res, next) ->
		console.log 'hello text event'
		res.reply 'hello world'

	
	route.text ['help', 'h', '帮助'], (data, req, res, next) ->
		res.reply	"""
			hello 测试命令
			joke 笑话
			ceshi 测试
			"""

	arr = [
		(data, req, res) ->

	]

	#测试
	# route.text ['ceshi', 'ch', '测试'], ceshi_controller.ceshi
	route.text ['ceshi', 'ch', '测试'], (data, req, res, next) ->

		res.waterfall "ceshi"

			

	#笑话
	route.text ['joke', '笑话'], joke_controller.joke