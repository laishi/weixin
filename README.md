weixin
======

wangbo's weixin server

微信服务器url配置为: http://40f70c9e.ngrok.com/node/wechat

前端使用nginx做反向代理
nginx部分配置如下

server {
    listen       80;
    server_name  127.0.0.1 40f70c9e.ngrok.com;

    #charset koi8-r;

    #access_log  logs/host.access.log  main;

    #将消息反向到微信服务器
    location /node {
        proxy_pass http://127.0.0.1:3001;
    }

    location / {
        proxy_pass http://127.0.0.1:10001;
    }
}

并在express中，去除/node前缀 see app.js

项目使用coffeescript编写
cd weixin & coffee -o app -wb coffee
