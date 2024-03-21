<template>
	<view>
		<cu-custom bgColor="White" :isBack="false">
			<block slot="content">个人中心</block>
		</cu-custom>
		<view class="padding-xl">
			<button class="cu-btn block bg-blue margin-tb-sm lg" @click="logoutToLogin">
				退出登陆</button>
		</view>
	</view>
</template>

<script>
	import {mapActions} from 'vuex'
	export default {
		data() {
			return {
				
			}
		},
		methods: {
			...mapActions(['logout']),
			logoutToLogin(){
				this.logout()
				uni.redirectTo({
				    url: '/pages/login/login'
				});
			},
		}
	}
</script>

<style>
	
</style>
