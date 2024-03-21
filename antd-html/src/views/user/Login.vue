<template>
  <div class="main">
    <a-form
      id="formLogin"
      class="user-layout-login"
      ref="formLogin"
      :form="form"
      @submit="handleSubmit"
      autocomplete="off"
    >
      <a-alert v-if="isLoginError" type="error" showIcon style="margin-bottom: 24px;" :message="errMessage" />
      <a-form-item>
        <a-input
                size="large"
                type="text"
                placeholder="输入用户名"
                v-decorator="[
                'username',
                {rules: [{ required: true, message: '请输入用户名' }], validateTrigger: 'blur'}
              ]"
        >
          <a-icon slot="prefix" type="user" :style="{ color: 'rgba(0,0,0,.25)' }"/>
        </a-input>
      </a-form-item>

      <a-form-item>
        <a-input
                size="large"
                type="password"
                autocomplete="false"
                placeholder="输入密码"
                v-decorator="[
                'password',
                {rules: [{ required: true, message: '请输入密码' }], validateTrigger: 'blur'}
              ]"
        >
          <a-icon slot="prefix" type="lock" :style="{ color: 'rgba(0,0,0,.25)' }"/>
        </a-input>
      </a-form-item>
      <a-form-item>
        <a-input-group size="large">
          <a-col :span="18">
            <a-input placeholder="验证码" v-decorator="[
                'captcha',
                {rules: [{ required: true, message: '请输入验证码' }], validateTrigger: 'blur'}
              ]" />
          </a-col>
          <a-col :span="6">
            <img :src="captcha" alt="验证码" style="width: 100%;height: 40px;cursor: pointer" @click="changeCaptcha">
          </a-col>
        </a-input-group>
      </a-form-item>
      <!--<a-form-item>
        <a-checkbox v-decorator="['rememberMe']">自动登录</a-checkbox>
        <router-link
          :to="{ name: 'recover', params: { user: 'aaa'} }"
          class="forge-password"
          style="float: right;"
        >忘记密码</router-link>
      </a-form-item>-->

      <a-form-item style="margin-top:24px">
        <a-button
          size="large"
          type="primary"
          htmlType="submit"
          class="login-button"
          :loading="state.loginBtn"
          :disabled="state.loginBtn"
        >确定</a-button>
      </a-form-item>

      <!--<div class="user-login-other">
        <span>其他登录方式</span>
        <a>
          <a-icon class="item-icon" type="alipay-circle"></a-icon>
        </a>
        <a>
          <a-icon class="item-icon" type="taobao-circle"></a-icon>
        </a>
        <a>
          <a-icon class="item-icon" type="weibo-circle"></a-icon>
        </a>
        <router-link class="register" :to="{ name: 'register' }">注册账户</router-link>
      </div>-->
    </a-form>

    <!--<two-step-captcha
      v-if="requiredTwoStepCaptcha"
      :visible="stepCaptchaVisible"
      @success="stepCaptchaSuccess"
      @cancel="stepCaptchaCancel"
    ></two-step-captcha>-->
  </div>
</template>

<script>
import api from '@/api'


export default {
  data () {
    return {
      captcha:'',
      loginBtn: false,
      // login type: 0 email, 1 username, 2 telephone
      loginType: 0,
      isLoginError: false,
      requiredTwoStepCaptcha: false,
      stepCaptchaVisible: false,
      form: this.$form.createForm(this),
      errMessage:'',
      state: {
        time: 60,
        loginBtn: false,
        // login type: 0 email, 1 username, 2 telephone
        loginType: 0,
        smsSendBtn: false
      }
    }
  },
    inject:['initSocket'],
  mounted() {
    this.changeCaptcha()
  }
  ,
  methods: {
    changeCaptcha(){
      this.$http({
        url:api.captcha,
        method:'post',
        responseType: 'blob',
      }).then(data => {
        let reader = new FileReader()
        reader.onload = (e) => {
          this.captcha = e.target.result
        }
        reader.readAsDataURL(data)
      }).catch(err => {
        console.log(err)
      })
    },
    handleSubmit (e) {
      e.preventDefault()
      const {
        form: { validateFields },
        state,
      } = this

      state.loginBtn = true

      const validateFieldsKey = ['username', 'password','captcha']

      validateFields(validateFieldsKey, { force: true }, (err, values) => {
        if (!err) {
          const loginParams = { ...values }
          this.$http.post(api.login,loginParams).then(res => {
            if(res.code != 0){
              this.requestFailed(res)
            }else{
              this.loginSuccess(res)
            }
          }).catch(err => {
            this.requestFailed(err)
          }).finally(() => {state.loginBtn = false})
        } else {
          setTimeout(() => {
            state.loginBtn = false
          }, 600)
        }
      })
    },
    loginSuccess (res) {
      this.$router.push({ path: '/' })
      // 延迟 1 秒显示欢迎信息
      setTimeout(() => {
        this.$notification.success({
          message: '欢迎',
          description: `欢迎回来`
        })
          this.initSocket()
      }, 1000)
      this.isLoginError = false
    },
    requestFailed (err) {
      this.changeCaptcha()
      this.errMessage = err.msg
      this.isLoginError = true
      this.$notification['error']({
        message: '错误',
        description: this.errMessage,
        duration: 4
      })
    }
  }
}
</script>

<style lang="less" scoped>
.user-layout-login {
  label {
    font-size: 14px;
  }

  .getCaptcha {
    display: block;
    width: 100%;
    height: 40px;
  }

  .forge-password {
    font-size: 14px;
  }

  button.login-button {
    padding: 0 15px;
    font-size: 16px;
    height: 40px;
    width: 100%;
  }

  .user-login-other {
    text-align: left;
    margin-top: 24px;
    line-height: 22px;

    .item-icon {
      font-size: 24px;
      color: rgba(0, 0, 0, 0.2);
      margin-left: 16px;
      vertical-align: middle;
      cursor: pointer;
      transition: color 0.3s;

      &:hover {
        color: #1890ff;
      }
    }

    .register {
      float: right;
    }
  }
}
</style>
