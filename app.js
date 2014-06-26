var express = require('express')
var wechat = require('wechat')
var app = express();

app.configure(function(){
  app.use(function(req, res, next) {
    if(/^\/node\/.*/.test(req.url)) {
      req.url = req.url.replace(/^\/node\//, '/')
    }
    console.log('req:', req.url)
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
