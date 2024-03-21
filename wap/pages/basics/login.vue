<template>
	<view>
		<view class="image">
			<image src="/static/logo.png" mode="aspectFit" alt=""/>
			<view class="tips">欢迎登录安防平台</view>
		</view>
		<form @submit="formSubmit">
			<view class="cu-form-group margin-top">
				<view class="title">用户名</view>
				<input placeholder="请输入用户名" name="username"></input>
			</view>
			<view class="cu-form-group">
				<view class="title">密码</view>
				<input placeholder="请输入密码" type="password" name="password"></input>
			</view>
			<view>
				<view class="padding-xl">
					<button class="cu-btn block bg-blue margin-tb-sm lg" :loading="loading" form-type="submit">
						登陆</button>
				</view>
			</view>
		</form>
	</view>
</template>

<script>
	let graceChecker = require("../../utils/graceChecker.js");
	export default {
		data(){
			return {
				loading:false
			}
		},
		methods: {
			formSubmit(e) {
				this.loading = true
				console.log('form发生了submit事件，携带数据为：' + JSON.stringify(e.detail.value))
		        //定义表单规则
		        var rule = [
		            {name:"username", checkType : "notnull", checkRule:"",  errorMsg:"请输入用户名"},
		            {name:"password", checkType : "notnull", checkRule:"",  errorMsg:"请输入密码"}
		        ];
		        //进行表单检查
		        var formData = e.detail.value;
		        var checkRes = graceChecker.check(formData, rule);
		        if(checkRes){
		            this.http.post(this.api.login,formData).then(res => {
						if(res.code == 0){
							uni.showToast({
								title:"登陆成功",
								icon:"none"
							})
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
		        }else{
		            uni.showToast({ title: graceChecker.error, icon: "none" });
					this.loading = false
		        }
			}
		}
	}
</script>

<style>
	.cu-form-group .title {
		min-width: calc(4em + 15px);
	}
	.image{
		text-align: center;
		margin-top: 10%;
	}
	.image image{
		width: 30%;
		height: 200px;
	}
	.image .tips{
		font-size: 2em;
		margin-bottom: 1em;
	}
</style>
