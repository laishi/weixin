// Generated by CoffeeScript 1.7.1
var Joke, User, async, mongoose;

async = require('async');

mongoose = require('mongoose');

Joke = mongoose.model('joke');

User = mongoose.model('user');

exports.joke = function(data, req, res, next) {
  console.log(data);
  return async.waterfall([
    function(cb) {
      return User.findOne({
        user_id: data.FromUserName
      }, function(err, one) {
        if (err) {
          console.log(err);
          cb('服务器错误1');
        } else if (!one) {
          User.create({
            user_id: data.FromUserName
          }, function(err, create_one) {
            return cb(null, create_one);
          });
        } else {
          cb(null, one);
        }
        return console.log("user is " + one);
      });
    }, function(one, cb) {
      console.log("query joke id = " + one.joke_id);
      return Joke.find({
        _id: {
          $gt: one.joke_id
        }
      }, function(err, nextOne) {
        console.log("nextJoke id = " + nextOne[0]);
        console.log("joke === " + nextOne + ", size=" + nextOne.length);
        if (err) {
          console.log(err);
          return cb("服务器错误");
        } else {
          return cb(null, one, nextOne);
        }
      });
    }, function(user, nextOne, cb) {
      var jokeOne;
      user.joke_id = nextOne[0].id;
      jokeOne = nextOne[0];
      user.save();
      if (jokeOne.pic_url.length > 0) {
        return cb(null, [
          {
            title: jokeOne.title,
            description: jokeOne.content,
            picurl: jokeOne.pic_url,
            url: jokeOne.pic_url
          }
        ]);
      } else {
        return cb(null, jokeOne.content);
      }
    }
  ], function(err, data) {
    if (err) {
      return res.reply(err);
    } else {
      return res.reply(data);
    }
  });
};

exports["new"] = function(req, res) {
  var joke;
  joke = req.query;
  return Joke.count({
    base_id: joke.base_id,
    from: joke.from
  }, function(err, count) {
    console.log("err=" + err + ", count=" + count);
    if (err) {
      console.log("count err " + err);
    } else if (count === 0) {
      Joke.create(joke);
    } else {
      console.log('repeat joke!! id=#{joke.base_id}');
    }
    return res.send({
      ok: true
    });
  });
};
