var express = require('express')
var wechat = require('wechat')
var app = express();
var mongoose = require('mongoose')
var fs = require('fs')
var autoIncrement = require('mongoose-auto-increment');
var MongoStore = require('connect-mongo')
var conf = require('./conf')

//连接mongodb
var connection = mongoose.connect('mongodb://192.168.4.13/test');
//使用autoIncement插件
autoIncrement.initialize(connection);
var Schema = mongoose.Schema
//加载模块
fs.readdirSync('./app/model/').forEach(function(file){
    require('./app/model/'+file)(mongoose, Schema)
})

mongoose.connection.on('error', function(err){
    console.log('err', err)
    app.stop()
})

mongoose.connection.on('open', function() {
  app.configure(function(){
    app.use(function(req, res, next) {
      if(/^\/node\/.*/.test(req.url)) {
        req.url = req.url.replace(/^\/node\//, '/')
      }
      next()
    })
    app.use(express.methodOverride());
    app.use(express.bodyParser());
    app.use(app.router);
    app.use(express.session({
      secret: conf.secret,
      maxAge: new Date(Date.now() + 3600000),
      store: new MongoStore(conf.db)
    }))
    //添加web路由
    var webRoute = require('./app/web_route')
    webRoute(app)
  });

  console.log("wexin Web server has started");

  app.listen(3001);

  var wechat_route = require('./app/wechat_route')

  app.use('/wechat', wechat('w231520', wechat_route));


  }
)

