import Vue from 'vue'
import Vuex from 'vuex'
Vue.use(Vuex)
export default new Vuex.Store({  
    state: {    
        user:{} 
    },  
    mutations: {  
        SET_USER_INFO(state, userInfo) {
            state.user = userInfo
			console.log(state.user)
        },  
        LOGOUT(state) {  
            state.user = {}
			uni.removeStorageSync("token")
        }  
    },
	actions: {
	    setUserInfo ({ commit },user) {
	        commit('SET_USER_INFO',user)
	    },
	    logout ({ commit }) {
	      commit('LOGOUT')
	    }
	}
})