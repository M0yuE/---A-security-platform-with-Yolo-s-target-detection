<template>
  <view class="content">
    <view class="header">
      <image src="../../static/shilu-login/logo.png"></image>
    </view>

    <view class="list">
      <view class="list-call">
        <image class="img" src="/static/shilu-login/1.png"></image>
        <input class="sl-input" v-model="username" type="text" maxlength="11" placeholder="输入用户名" />
      </view>
      <view class="list-call">
        <image class="img" src="/static/shilu-login/2.png"></image>
        <input class="sl-input" v-model="password" type="text" maxlength="32" placeholder="输入密码" password="true" />
      </view>

    </view>

    <view class="button-login" hover-class="button-hover" @tap="bindLogin()">
      <text>登录</text>
    </view>

    <view class="agreenment">
      <navigator url="forget" open-type="navigate">忘记密码</navigator>
      <text>|</text>
      <navigator url="reg" open-type="navigate">注册账户</navigator>
    </view>
  </view>
</template>

<script>
  export default {
    data() {
      return {
        username: '',
        password: ''
      };
    },
    methods: {
      bindLogin() {
        if (!this.username.length) {
          uni.showToast({
            icon: 'none',
            title: '请输入用户名'
          });
          return;
        }
        if (!this.password.length) {
          uni.showToast({
            icon: 'none',
            title: '请输入密码'
          });
          return;
        }
		let formData = {username:this.username,password:this.password}
        this.http.post(this.api.login,formData).then(res => {
        	if(res.code == 0){
        		uni.showToast({
        			title:"登陆成功",
        			icon:"none"
        		})
				//let info = uni.getSystemInfoSync()
				//let cid = plus.push.getClientInfo()
				
				// console.log(res.data)
				
				
				/* console.logJSON.stringify(info)
				let params = JSON.stringify(info) + JSON.stringify(cid)
				this.http.post(this.api.wapInfo,{params}).then(res => {
					uni.showToast({ title: JSON.stringify(res), icon: "none" });
				}).catch(e => {
					uni.showToast({ title: JSON.stringify(e), icon: "none" });
				}) */
        		uni.redirectTo({
        		    url: '/pages/index/index'
        		});
        	}else{
        		uni.showToast({
        			title:res.msg,
        			icon:"none"
        		})
        	}
        	this.loading = false
        }).catch(e => {
        	uni.showToast({ title: JSON.stringify(e), icon: "none" });
        })

      }
    }
  }
</script>

<style>
  .content {
    display: flex;
    flex-direction: column;
    justify-content: center;
  }

  .header {
    width: 161rpx;
    height: 161rpx;
    background: rgba(63, 205, 235, 1);
    box-shadow: 0rpx 12rpx 13rpx 0rpx rgba(63, 205, 235, 0.47);
    border-radius: 50%;
    margin-top: 30rpx;
    margin-left: auto;
    margin-right: auto;
  }

  .header image {
    width: 161rpx;
    height: 161rpx;
    border-radius: 50%;
  }

  .list {
    display: flex;
    flex-direction: column;
    padding-top: 50rpx;
    padding-left: 70rpx;
    padding-right: 70rpx;
  }

  .list-call {
    display: flex;
    flex-direction: row;
    justify-content: space-between;
    align-items: center;
    height: 100rpx;
    color: #333333;
    border-bottom: 0.5px solid #e2e2e2;
  }

  .list-call .img {
    width: 40rpx;
    height: 40rpx;
  }

  .list-call .sl-input {
    flex: 1;
    text-align: left;
    font-size: 32rpx;
    margin-left: 16rpx;
  }

  .button-login {
    color: #FFFFFF;
    font-size: 34rpx;
    width: 470rpx;
    height: 100rpx;
    background: linear-gradient(-90deg, rgba(63, 205, 235, 1), rgba(188, 226, 158, 1));
    box-shadow: 0rpx 0rpx 13rpx 0rpx rgba(164, 217, 228, 0.2);
    border-radius: 50rpx;
    line-height: 100rpx;
    text-align: center;
    margin-left: auto;
    margin-right: auto;
    margin-top: 100rpx;
  }

  .button-hover {
    background: linear-gradient(-90deg, rgba(63, 205, 235, 0.8), rgba(188, 226, 158, 0.8));
  }

  .agreenment {
    display: flex;
    flex-direction: row;
    justify-content: center;
    align-items: center;
    font-size: 30rpx;
    margin-top: 80rpx;
    color: #FFA800;
    text-align: center;
    height: 40rpx;
    line-height: 40rpx;
  }

  .agreenment text {
    font-size: 24rpx;
    margin-left: 15rpx;
    margin-right: 15rpx;
  }
</style>
