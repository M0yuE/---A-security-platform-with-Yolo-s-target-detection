<template>
	<view>
		
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

</style>
<template>
	<view>
		<cu-custom bgColor="White" :isBack="false">
			<block slot="content">合作</block>
		</cu-custom>
		<!-- <navigator class="back_button" hover-class="none" url="./index">
			<button hover-class="none" plain="true">返回</button>
		</navigator> -->
		<view class="header">
			<view>
				<image class="img" src="../../static/shilu-login/cooperation.jpg"></image>
				<view class="logo_font">
					河北天地人和科技有限公司
				</view>
			</view>
		</view>
		<view class="content_about">
			<view class="copyright">
				本公司成接各种微信小程序、网站制作、移动端APP开发
			</view>
			<view class="copyrighr_num">
				如有合作请联系： 123456789
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
	  height: 323rpx;
	  background-color: #ffffff;
	  margin-top: 90rpx;
	  margin-left: auto;
	  margin-right: auto;
	}
	.header image {
	  display: block;
	  width: 377rpx;
	  height: 258rpx;
	  margin-left: auto;
	  margin-right: auto;
	  font: 700 80rpx;
	}
	.logo_font {
		font-size: 55rpx;
		font-weight: 500;
		font-family: 'STXingkai';
	}
	.content_about {
		width: 650rpx;
		height: 100rpx;
		margin-top: 400rpx;
		margin-left: auto;
		margin-right: auto;
		font-size: 37rpx;
		font-weight: 400;
		text-align: center;
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
