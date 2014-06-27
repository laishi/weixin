
async = require 'async'
mongoose = require 'mongoose'
Joke = mongoose.model 'joke'
User = mongoose.model 'user'

exports.joke = (data, req, res, next) ->
	#
	console.log data
	async.waterfall [
		(cb) ->
			User.findOne user_id: data.FromUserName, (err, one) ->
				if err 
					console.log err
					cb '服务器错误1'
				else if !one
					User.create user_id: data.FromUserName, (err, create_one)->
						cb null, create_one
				else
					cb null, one
				console.log "user is #{one}"
		(one, cb) ->
			# one.joke_id = one.joke_id+1
			# Joke.find({}, null, {sort: [['_id', -1]]}, callback)
			console.log "query joke id = #{one.joke_id}"
			Joke.find {_id:{$gt:one.joke_id}}, (err,nextOne) ->
				console.log "nextJoke id = #{nextOne[0]}"
				console.log "joke === #{nextOne}, size=#{nextOne.length}"
				if err
					console.log err
					cb "服务器错误"
				else
					cb null, one, nextOne

		(user, nextOne, cb)->
			user.joke_id = nextOne[0].id
			jokeOne = nextOne[0]
			user.save()
			if jokeOne.pic_url.length > 0
				cb null, [{title: jokeOne.title, description: jokeOne.content, picurl: jokeOne.pic_url, url: jokeOne.pic_url}]
			else
				cb null, jokeOne.content


	],
	(err, data) ->
		if err
			res.reply err
		else
			res.reply data
	


#新增joke
exports.new  = (req, res) ->
	joke = req.query
	Joke.count {base_id:joke.base_id,from : joke.from},(err,count) ->
		console.log "err=#{err}, count=#{count}"
		if err
			console.log "count err #{err}"
		else if count == 0
			Joke.create joke
		else
			console.log 'repeat joke!! id=#{joke.base_id}'
		res.send {ok: true}