import { asyncRouterMap } from '@/config/router.config'
import {resetRouter} from '@/router'
function hasPermission (permission, route) {
  if (route.meta && route.meta.permission) {
    if(permission.join(',').indexOf(route.meta.permission) != -1){
      return true
    }
    return false
  }
  return true
}
function filterAsyncRouter (routerMap, roles) {
  const accessedRouters = routerMap.filter(route => {
    if (hasPermission(roles, route)) {
      if (route.children && route.children.length) {
        route.children = filterAsyncRouter(route.children, roles)
      }
      return true
    }
    return false
  })
  return accessedRouters
}
function getUserFirstRoute(route){
  if(route.children && route.children.length > 0){
    return getUserFirstRoute(route.children[0])
  }else{
    return route
  }
}
function mayGoRouter(path,userRouters){
  let flag = false
  for(let index in userRouters){
    if(path === userRouters[index].path){
      flag = true
      break
    }else{
      if(userRouters[index].children && userRouters[index].children.length > 0){
        flag = mayGoRouter(path,userRouters[index].children)
      }
    }
  }
  return flag
}
// 深拷贝
const clone = (obj) => {
  var o;
  // 如果  他是对象object的话  , 因为null,object,array  也是'object';
  if (typeof obj === 'object') {
    // 如果  他是空的话
    if (obj === null) {
      o = null;
    }
    else {
      // 如果  他是数组arr的话
      if (obj instanceof Array) {
        o = [];
        for (var i = 0, len = obj.length; i < len; i++) {
          o.push(clone(obj[ i ]));
        }
      }
      // 如果  他是对象object的话
      else {
        o = {};
        for (var j in obj) {
          o[ j ] = clone(obj[ j ]);
        }
      }
    }
  }
  else {
    o = obj;
  }
  return o;
}


const user = {
  state: {
    name: '',
    welcome: '',
    avatar: '',
    perms: [],
    userInfo: {},
    userRouters:[],
    warnCount:0
  },

  mutations: {
      SET_WARN_COUNT:(state,count) => {
          state.warnCount = count
      },
    SET_NAME: (state, { name, welcome }) => {
      state.name = name
      state.welcome = welcome
    },
    SET_AVATAR: (state, avatar) => {
      state.avatar = avatar
    },
    SET_PERMS: (state, perms) => {
      state.perms = perms
    },
    SET_USER_INTO: (state, userInfo) => {
      state.userInfo = userInfo
    },
    GENERATE_ROUTES: (state) => {
      let arr = clone(asyncRouterMap)
      const accessdRouters = filterAsyncRouter(arr,state.perms)
      state.userRouters = accessdRouters
    },
    CLEAR_USER_INFO:(state) => {
      state.name = ''
      state.perms = []
      state.userInfo = []
      state.userRouters = []
      resetRouter()
    }
  },
  getters:{
      getWarnCount(state){
          return state.warnCount
      },
    getPermission(state){
      return state.perms
    },
    isHasPermission:(state) => (perm) =>{
      return state.perms.indexOf(perm) !== -1
    },
    canGoRouter:(state) => (rout) => {
      return mayGoRouter(rout,state.userRouters)
    },
    getUserRouters(state){
      return state.userRouters
    },
    getUserGoRouter(state){
      if(state.userRouters.length == 0){
        return
      }
      const router = state.userRouters.find(item => item.path === '/')
      return getUserFirstRoute(router)
    },
    getUserInfo(state){
      return state.userInfo
    },
    getUserMenu(state){
      if(state.userRouters.length == 0){
        return
      }
      return state.userRouters.find(item => item.path === '/').children
    },
  },
  actions: {
      SetWarnCount({ commit },res){
          commit('SET_WARN_COUNT',res)
      },
    GetUserInfo ({ commit },res) {
        commit('SET_USER_INTO',res.user)
        commit('SET_PERMS',res.perms)
        //构建路由
        commit('GENERATE_ROUTES')
    },
    ClearUserInfo ({ commit },res) {
      commit('CLEAR_USER_INFO')
    }
  }
}

export default user
