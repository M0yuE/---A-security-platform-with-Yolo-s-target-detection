import Vue from 'vue'
import App from './App'

import basics from './pages/basics/home.vue'
Vue.component('basics',basics)
import control from './pages/index/control.vue'
Vue.component('control',control)
import realdata from './pages/index/data.vue'
Vue.component('realdata',realdata)
import message from './pages/index/message.vue'
Vue.component('message',message)
import my from './pages/index/my.vue'
Vue.component('my',my)
import info from './pages/index/info.vue'
Vue.component('info',info)
import about from './pages/index/about.vue'
Vue.component('about',about)
import cooperation from './pages/index/cooperation.vue'
Vue.component('cooperation',cooperation)

import components from './pages/component/home.vue'
Vue.component('components',components)

import plugin from './pages/plugin/home.vue'
Vue.component('plugin',plugin)

import cuCustom from './colorui/components/cu-custom.vue'
Vue.component('cu-custom',cuCustom)

Vue.config.productionTip = false

App.mpType = 'app'

const app = new Vue({
    ...App
})
app.$mount()

 



