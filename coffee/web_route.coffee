
joke_controller = require './controller/joke_controller'

module.exports = (app) ->

	app.post '/joke/new', joke_controller.new

	app.get '/joke/new', joke_controller.new