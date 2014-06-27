
#如果是微信请求，那么该中间件将构建玩家session
module.exports = (data, req, res, next) ->
	user_id = data.FromUserName
	
