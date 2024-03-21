import uni_request from './uni_request.js'
import store from '../store'

const request = uni_request({ // 有效配置项只有三个
	// baseURL: 'http://192.168.43.34:8889', //baseURL
	baseURL: 'http://127.0.0.1:8889', //baseURL
	timeout: 5000, // 超时时间
	heaers: {
	}
})

request.interceptors.request.use((config, ...args) => { // 请求拦截器（可以设置多个, 同时可以也可以使用异步方法）
	  const token = uni.getStorageSync("token")
	  if (token) {
		config.headers['token'] = token // 让每个请求携带自定义 token 请根据实际情况自行修改
	  }
	  //配置请求头
	  let header = config.headers['send']//一般情况下就默认提交方式即可(下面的if)，如需发送json数据的话在header里面加send=json即可
	  if(!header || header != 'json'){
		config.headers['Content-Type'] = 'application/x-www-form-urlencoded'
		config.data = args[2]
	  }
	  return config
})

request.interceptors.response.use((response, ...args) => { // 响应拦截器（可以设置多个, 同时可以也可以使用异步方法）
	let flushToken = response.header['flush-token']
	  if(flushToken && flushToken == "true"){//从header判断token
	    let token = response.header['token']
	    if(token && token.trim() != ''){
			
			console.log(token)
			
	      uni.setStorageSync('token',token)
	    }
	  }
	  let data = response.data
	  if(data.code && data.code == 403){
			  uni.showToast({
				  title: data.msg,
				  duration: 1000
			  });
			uni.removeStorageSync('token');
			store.dispatch('logout')
			return null
	  }
	  if(data.code && data.code == 503){
	      uni.showToast({
			  title: data.msg,
			  duration: 1000
	      });
	    return null
	  }
	  // console.log(response)
	  return response
})


request.overtime = (...args) => { // 超时钩子函数（可以设置多个, 同时可以也可以使用异步方法）
	uni.showToast({
	  title: '请求超时',
	  duration: 1000
	});
}

request.onerror = (...args) => { // 请求失败统一处理方法（可以设置多个, 同时可以也可以使用异步方法）
	console.log('网络请求失败了', `url为${args[1]}`)
	uni.showToast({
	  title: `网络请求失败了, url为${args[1]}`,
	  duration: 1000
	});
}
export default request
/* request.get('/').then(res => { // 默认使用实例化时配置的 baseURL
	console.log(res)
}).catch(e => console.error(e))

request.get('http://xxx.com').then(res => { // 也可以使用配置的 baseURL 之外的 url，但是注意 url 路径要写完整
	console.log(res)
}).catch(e => console.error(e))

// 取消一个请求
const task = request.get('/cancel') // 如果想要取消某个请求，需要在 then 之前将 request.get 方法返回的 promise 对象保存在一个变量里
task.then(res => {
	console.log(res)
}).catch(e => console.error(e)) // 网络请求失败：主动取消
task.cancel() */
// 在需要的时候调用 cancel 方法
// 会使当前网络请求取消并且使 request.get 方法返回的 promise 进入 reject 状态
// 可被 catch 捕获，错误信息为 【网络请求失败：主动取消】
// 如果在请求拦截器的异步期间取消，那么会在请求拦截器的异步操作结束后直接使返回的 Promise 进入 reject 状态，并不会发出网络请求