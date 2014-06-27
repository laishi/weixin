var express = require('express')
var wechat = require('wechat')
var app = express();
var mongoose = require('mongoose')
var fs = require('fs')
var autoIncrement = require('mongoose-auto-increment');
var webRoute = require('./app/web_route')

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
  //添加web路由
  webRoute(app)
});

console.log("wexin Web server has started");

app.listen(3001);

var wechat_route = require('./app/wechat_route')

app.use('/wechat', wechat('w231520', wechat_route));

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