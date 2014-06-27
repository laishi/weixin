
autoIncrement = require 'mongoose-auto-increment'
module.exports = (mongoose, Schema) ->
  JokeSchema = new Schema
      title:{type: String ,default : ""}
      content: {type: String ,default : ""}
      pic_url: {type: String ,default : ""}
      #来源方id
      base_id: {type: Number ,default : 0}
      #来源 [qiushibaike]
      from: {type: String ,default : ""}


  mongoose.plugin autoIncrement.plugin, 'joke'
  Joke = mongoose.model('joke', JokeSchema)
