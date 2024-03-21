// with polyfills
import 'core-js/stable'
import 'regenerator-runtime/runtime'

import Vue from 'vue'
import App from './App.vue'
import router from './router'
import store from './store/'
import { VueAxios } from './utils/request'

import bootstrap from './core/bootstrap'
import './core/lazy_use'
import './permission' // permission control
import './utils/filter' // global filter
import './components/global.less'
import CKEditor from '@ckeditor/ckeditor5-vue';
import vcolorpicker from 'vcolorpicker'




//============
import dataV from '@jiaminghi/data-view';
Vue.use(dataV);

// 按需引入vue-awesome图标
import Icon from 'vue-awesome/components/Icon';
import 'vue-awesome/icons/chart-bar.js';
import 'vue-awesome/icons/chart-area.js';
import 'vue-awesome/icons/chart-pie.js';
import 'vue-awesome/icons/chart-line.js';
import 'vue-awesome/icons/align-left.js';

// 全局注册图标
Vue.component('icon', Icon);

// 适配flex
// import '@/common/flexible.js';
import './common/flexible.js';


// 引入全局css
import './assets/scss/style.scss';


//引入echart
import echarts from 'echarts'
Vue.prototype.$echarts = echarts







Vue.config.productionTip = false
Vue.prototype.indexOf = (targetData,originArr,key) => {
  for(let i in originArr){
    if(originArr[i][key] && targetData[key] && originArr[i][key] == targetData[key]){
      return i
    }
  }
  return -1
}
// mount axios Vue.$http and this.$http
Vue.use(VueAxios)
Vue.use(CKEditor)
Vue.use(vcolorpicker)

new Vue({
  router,
  store,
  created: bootstrap,
  render: h => h(App)
}).$mount('#app')
