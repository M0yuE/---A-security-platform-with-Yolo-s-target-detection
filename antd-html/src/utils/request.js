import Vue from 'vue'
import axios from 'axios'
import store from '@/store'
import notification from 'ant-design-vue/es/notification'
import { VueAxios } from './axios'
import { ACCESS_TOKEN } from '@/store/mutation-types'
import router from '@/router'
import qs from 'qs'
import NProgress from 'nprogress'

// 创建 axios 实例
const service = axios.create({
  baseURL: process.env.VUE_APP_API_BASE_URL, // api base_url
  timeout: 200000 // 请求超时时间
})

const err = (error) => {
  if (error.response) {
    const data = error.response.data
    const token = Vue.ls.get(ACCESS_TOKEN)
    if (error.response.status === 403) {
      notification.error({
        message: 'Forbidden',
        description: data.message
      })
    }
    if (error.response.status === 401 && !(data.result && data.result.isLogin)) {
      notification.error({
        message: 'Unauthorized',
        description: 'Authorization verification failed'
      })
      if (token) {
        store.dispatch('Logout').then(() => {
          setTimeout(() => {
            window.location.reload()
          }, 1500)
        })
      }
    }
  }
  return Promise.reject(error)
}

// request interceptor
service.interceptors.request.use(config => {
  const token = Vue.ls.get(ACCESS_TOKEN)
  if (token) {
    config.headers['token'] = token // 让每个请求携带自定义 token 请根据实际情况自行修改
  }
  //配置请求头
  let header = config.headers['send']//一般情况下就默认提交方式即可(下面的if)，如需发送json数据的话在header里面加send=json即可
  if(header && header == 'json'){// application/x-www-form-urlencoded
    config.headers[config.method]['Content-Type'] = 'application/json;charset=UTF-8'
  }else if(header && header == 'file'){

  }else{
    config.data = qs.stringify(config.data)
  }
  return config
}, err)

// response interceptor
service.interceptors.response.use((response) => {
  let flushToken = response.headers['flush-token']
  if(flushToken && flushToken == "true"){//从header判断token
    let token = response.headers['token']
    if(token && token.trim() != ''){
      Vue.ls.set(ACCESS_TOKEN,token)
    }
  }
  let data = response.data
  if(data.code && data.code == 403){
    notification.error({
      message: data.msg,
      description: '错误码：' + data.code
    })
    store.dispatch('ClearUserInfo')
    router.push({ name: 'login' })
    NProgress.done()
    return null
  }
  if(data.code && data.code == 503){
      notification.error({
          message: data.msg,
          description: '错误码：' + data.code
      })
    return null
  }
  return response.data
}, err)

const installer = {
  vm: {},
  install (Vue) {
    Vue.use(VueAxios, service)
  }
}

export {
  installer as VueAxios,
  service as axios
}
