
autoIncrement = require 'mongoose-auto-increment'
module.exports = (mongoose, Schema) ->
  JokeSchema = new Schema
      title: String
      content: String
      pic_url: String
      #来源方id
      base_id: Number
      #来源 [qiushibaike]
      from: String


  mongoose.plugin autoIncrement.plugin, 'joke'
  Joke = mongoose.model('user_base', JokeSchema)
