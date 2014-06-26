var express = require('express')
var wechat = require('wechat')
var app = express();
var mongoose = require('mongoose')
var fs = require('fs')
var autoIncrement = require('mongoose-auto-increment');

app.configure(function(){
  app.use(function(req, res, next) {
    if(/^\/node\/.*/.test(req.url)) {
      req.url = req.url.replace(/^\/node\//, '/')
    }
    next()
  })
});

app.configure('development', function(){
  app.use(express.static(__dirname + '/public'));
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true }));
});

app.configure('production', function(){
  var oneYear = 31557600000;
  app.use(express.static(__dirname + '/public', { maxAge: oneYear }));
  app.use(express.errorHandler());
});

console.log("wexin Web server has started");

app.listen(3001);

var wechat_route = require('./app/wechat_route')

app.use('/wechat', wechat('w231520', wechat_route));

//连接mongodb
var connection = mongoose.connect('mongodb://localhost/test');
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