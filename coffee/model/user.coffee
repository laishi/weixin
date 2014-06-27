
autoIncrement = require 'mongoose-auto-increment'
module.exports = (mongoose, Schema) ->
  JokeSchema = new Schema
      # title: String
      # content: String
      # pic_url: String
      # #来源方id
      # base_id: Number
      # #来源 [qiushibaike]
      # from: String
      joke_id : {type : Number ,default : 0}
      user_id : String

  mongoose.plugin autoIncrement.plugin, 'user'
  Joke = mongoose.model('user', JokeSchema)
