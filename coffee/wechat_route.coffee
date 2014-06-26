
util = require 'util'

class Route

	constructor: ->
		self = this
		['text', 'image', 'voice', 'video', 'location', 'link', 'event'].forEach (type) ->
			self["#{type}_cache"] = {}
			self[type]= (name, fn)->
				if util.isArray(name)
					name.forEach (item) -> self["#{type}_cache"][item] = fn
				else
					self["#{type}_cache"][name] = fn
				


route = new Route()
require('./route')(route)
console.log route

module.exports = (req, res, next) ->
	data = req.weixin
	# console.log route["#{data.MsgType}_cache"]
	# console.log route["#{data.MsgType}_cache"][data.Content]
	# console.log(typeof data.Content)
	fn = route["#{data.MsgType}_cache"][data.Content]
	if fn then fn(data, req, res, next) else console.log "can`t find route to process, MsgType=#{data.MsgType}, Content=#{data.Content}, route=#{route}"

	
