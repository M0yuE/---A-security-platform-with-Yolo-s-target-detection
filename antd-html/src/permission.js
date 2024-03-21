import Vue from 'vue'
import router from './router'
import store from './store'

import NProgress from 'nprogress' // progress bar
import '@/components/NProgress/nprogress.less' // progress bar custom style
import { setDocumentTitle, domTitle } from '@/utils/domUtil'
import { ACCESS_TOKEN } from '@/store/mutation-types'
import api from '@/api/index'


NProgress.configure({ showSpinner: false }) // NProgress Configuration

const whiteList = ['login', 'register', 'registerResult'] // no redirect whitelist
let that = Vue.prototype
router.beforeEach((to, from, next) => {
	NProgress.start() // start progress bar
	to.meta && (typeof to.meta.title !== 'undefined' && setDocumentTitle(`${to.meta.title} - ${domTitle}`))
	// 开始标记
	if (Vue.ls.get(ACCESS_TOKEN)) {
		/* has token */
		if (to.path === '/user/login') {
			let rout = store.getters.getUserGoRouter
			if(rout){
				next({ path: rout.path })
			}else{
				next()
			}
			NProgress.done()
		} else {
			if(!store.getters.perms || store.getters.perms.length == 0){
				that.$http.get(api.getUserInfo).then(res => {
					if(!res){
						return
					}
					if(!res.perms || res.perms.length == 0){
						that.$notification['error']({
							message: '没有权限！',
							description: '此用户没有任何权限！请联系管理员！',
							duration: 4
						})
						next({name:'login'})
						NProgress.done()
						return
					}
					store.dispatch('GetUserInfo', res).then(() => {
						router.addRoutes(store.getters.getUserRouters)
						const redirect = decodeURIComponent(from.query.redirect || to.path)
						if (to.path === redirect) {
							if(to.path === '/'){
								next({path:store.getters.getUserGoRouter.path})
							}else{
								// hack方法 确保addRoutes已完成 ,set the replace: true so the navigation will not leave a history record
								next({ ...to, replace: true })
							}
						} else {
							// 跳转到目的路由(判断是否有当前路由的权限)
							let canGo = store.getters.canGoRouter(redirect)
							if(canGo){
								next({ path: redirect })
							}else{
								next({path:store.getters.getUserGoRouter.path})
							}
						}
					})
				})
			} else {
				//获取用户的有权限访问的
				if (to.path === '/user/login') {
					next({path:store.getters.getUserGoRouter.path})
					NProgress.done()
				}else{
					next()
				}
			}
		}
	} else {
		if (whiteList.includes(to.name)) {
			// 在免登录白名单，直接进入
			next()
		} else {
			next({ path: '/user/login', query: { redirect: to.fullPath } })
			NProgress.done() // if current page is login will not trigger afterEach hook, so manually handle it
		}
	}
	// 结束标记
})

router.afterEach(() => {
	NProgress.done() // finish progress bar
})
