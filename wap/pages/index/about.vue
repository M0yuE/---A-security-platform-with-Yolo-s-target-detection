<template>
	<view>
		<cu-custom bgColor="White" :isBack="false">
			<block slot="content">关于我们</block>
		</cu-custom>
		<!-- <navigator class="back_button" hover-class="none" url="./index">
			<button hover-class="none" plain="true">返回</button>
		</navigator> -->
		<view class="header">
			<view>
				<image class="img" src="../../static/shilu-login/logo.svg"></image>
				<view class="logo_font">
					智能安防云平台
				</view>
				<view class="logo_version">
					Version 1.0.0
				</view>
			</view>
		</view>
		<view class="content_about">
			<view class="copyright">
				Copyright 2020-2021 河北建筑工程学院
			</view>
			<view class="copyrighr_num">
				冀ICP备 123456789号
			</view>
		</view>
	</view>
</template>

<script>
	export default {
		data() {
			return {
				
			}
		},
		methods: {
			
		}
	}
</script>

<style>
	.fixed {
		position: fixed;
		z-index: 99;
	}
	.header {
	  width: 650rpx;
	  height: 100rpx;
	  background-color: #ffffff;
	  margin-top: 90rpx;
	  margin-left: auto;
	  margin-right: auto;
	}
	.header image {
	  width: 327rpx;
	  height: 100rpx;
	  font: 700 80rpx;
	}
	.logo_font {
		position: absolute;
		margin-top: -98rpx;
		margin-left: 210rpx;
		font-size: 55rpx;
		font-weight: 600;
	}
	.logo_version {
		font-size: 40rpx;
		font-weight: 400;
		text-align: center;
	}
	.content_about {
		width: 650rpx;
		height: 100rpx;
		margin-top: 600rpx;
		margin-left: auto;
		margin-right: auto;
		font-size: 30rpx;
		font-weight: 400;
		text-align: center;
		color: #cccccc;
	}
	.copyright {
		margin-bottom: 5rpx;
	}
	/* .back_button {
		background-color: #5E00FF;
		width: 80rpx;
		height: 50rpx;
		position: absolute;
		margin-top: -77rpx;
		margin-left: 65rpx;
		font-size: 20rpx;
	} */

</style>
