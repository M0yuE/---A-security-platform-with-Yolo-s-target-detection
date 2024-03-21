const path = require('path')
const webpack = require('webpack')
const createThemeColorReplacerPlugin = require('./config/plugin.config')

function resolve (dir) {
  return path.join(__dirname, dir)
}

/**
 * check production or preview(pro.loacg.com only)
 * @returns {boolean}
 */
function isProd () {
  return process.env.NODE_ENV === 'production'
}

const assetsCDN = {
  css: [],
  // https://unpkg.com/browse/vue@2.6.10/
  js: [
    '//cdn.bootcss.com/vue/2.6.10/vue.min.js',
    //'//cdn.jsdelivr.net/npm/vue@2.6.10/dist/vue.min.js',
    'https://cdn.bootcss.com/vue-router/3.1.3/vue-router.js',
    //'//cdn.jsdelivr.net/npm/vue-router@3.1.3/dist/vue-router.min.js',
    'https://cdn.bootcss.com/vuex/3.1.1/vuex.min.js',
    //'//cdn.jsdelivr.net/npm/vuex@3.1.1/dist/vuex.min.js',
    'https://cdn.bootcss.com/axios/0.19.0/axios.min.js',
    //'//cdn.jsdelivr.net/npm/axios@0.19.0/dist/axios.min.js'
  ]
}

// webpack build externals
const prodExternals = {
  vue: 'Vue',
  'vue-router': 'VueRouter',
  vuex: 'Vuex',
  axios: 'axios'
}

// vue.config.js
const vueConfig = {
  configureWebpack: {
    // webpack plugins
    plugins: [
      // Ignore all locale files of moment.js
      new webpack.IgnorePlugin(/^\.\/locale$/, /moment$/)
    ],
    // if prod is on, add externals
    externals: isProd() ? prodExternals : {}
  },

  chainWebpack: (config) => {
    config.resolve.alias
      .set('@$', resolve('src'))
      




      .set('_c', resolve('src/components')) // key,value自行定义，比如.set('@@', resolve('src/components'))





    const svgRule = config.module.rule('svg')
    svgRule.uses.clear()
    svgRule
      .oneOf('inline')
      .resourceQuery(/inline/)
      .use('vue-svg-icon-loader')
      .loader('vue-svg-icon-loader')
      .end()
      .end()
      .oneOf('external')
      .use('file-loader')
      .loader('file-loader')
      .options({
        name: 'assets/[name].[hash:8].[ext]'
      })

    // if prod is on
    // assets require on cdn
    if (isProd()) {
      config.plugin('html').tap(args => {
        args[0].cdn = assetsCDN
        return args
      })
    }
  },

  css: {
    loaderOptions: {
      less: {
        modifyVars: {
          // less vars，customize ant design theme

          // 'primary-color': '#F5222D',
          // 'link-color': '#F5222D',
          // 'border-radius-base': '4px'
        },
        // do not remove this line
        javascriptEnabled: true
      }
    }
  },

  devServer: {
    // development server port 8000
    port: 8000,
    // If you want to turn on the proxy, please remove the mockjs /src/main.jsL11
    proxy: {
        '/weather_mini': {
            target: 'http://wthrcdn.etouch.cn',
            changeOrigin: true,
        },
       '/api': {
         target: 'http://127.0.0.1:8889',
        // target: 'http://192.168.60.121:8889',
         ws: true,
         changeOrigin: true,
         pathRewrite: {
           '^/api': '/'
         }
       },
      '/image': {
        // target: 'http://127.0.0.1/',
        target: 'http://192.168.60.121/',
        ws: false,
        changeOrigin: true,
      },

     }
  },

  // disable source map in production
  productionSourceMap: false,
  lintOnSave: false,
  // babel-loader no-ignore node_modules/*
  transpileDependencies: []
}

// preview.pro.loacg.com only do not use in your production;
if (process.env.VUE_APP_PREVIEW === 'true') {
  console.log('VUE_APP_PREVIEW', true)
  // add `ThemeColorReplacer` plugin to webpack plugins
  vueConfig.configureWebpack.plugins.push(createThemeColorReplacerPlugin())
}

//===========
// const resolve = dir => {
//   return path.join(__dirname, dir)
// }

module.exports = vueConfig
