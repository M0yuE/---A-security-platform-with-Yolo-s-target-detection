<template>
	<view>
		<info v-if="PageCur=='info'" @changePage="changePage"></info>
		<control v-if="PageCur=='control'"></control>
		<realdata v-if="PageCur=='data'"></realdata>
		<message v-if="PageCur=='message'"></message>
		<my v-if="PageCur=='my'"></my>
		
		<about v-if="PageCur=='about'"></about>
		
		<cooperation v-if="PageCur=='cooperation'"></cooperation>
		
		<basics v-if="PageCur=='basics'"></basics>
		<components v-if="PageCur=='component'"></components>
		<plugin v-if="PageCur=='plugin'"></plugin>
		<view class="cu-bar tabbar bg-white shadow foot">
			<view class="action" @click="NavChange" data-cur="info">
				<view class='cuIcon-cu-image'>
					<image :src="'/static/tabbar/info' + [PageCur=='info'?'_cur':''] + '.png'"></image>
				</view>
				<view :class="PageCur=='info'?'text-green':'text-gray'">首页</view>
			</view>
			<view class="action" @click="NavChange" data-cur="data">
				<view class='cuIcon-cu-image'>
					<image :src="'/static/tabbar/data' + [PageCur=='data'?'_cur':''] + '.png'"></image>
				</view>
				<view :class="PageCur=='data'?'text-green':'text-gray'">实时数据</view>
			</view>
			<view class="action" @click="NavChange" data-cur="control">
				<view class='cuIcon-cu-image'>
					<image :src="'/static/tabbar/control' + [PageCur=='control'?'_cur':''] + '.png'"></image>
				</view>
				<view :class="PageCur=='control'?'text-green':'text-gray'">控制中心</view>
			</view>
			<view class="action" @click="NavChange" data-cur="message">
				<view class='cuIcon-cu-image'>
					<image :src="'/static/tabbar/message' + [PageCur=='message'?'_cur':''] + '.png'"></image>
				</view>
				<view :class="PageCur=='message'?'text-green':'text-gray'">预警消息</view>
			</view>
			<view class="action" @click="NavChange" data-cur="my">
				<view class='cuIcon-cu-image'>
					<image :src="'/static/tabbar/my' + [PageCur=='my'?'_cur':''] + '.png'"></image>
				</view>
				<view :class="PageCur=='my'?'text-green':'text-gray'">个人中心</view>
			</view>
			<view class="action" @click="NavChange" data-cur="about" style="display: none;">
				<view class='cuIcon-cu-image'>
					<image :src="'/static/tabbar/my' + [PageCur=='my'?'_cur':''] + '.png'"></image>
				</view>
				<view :class="PageCur=='about'?'text-green':'text-gray'">关于我们</view>
			</view>
			<view class="action" @click="NavChange" data-cur="cooperation" style="display: none;">
				<view class='cuIcon-cu-image'>
					<image :src="'/static/tabbar/my' + [PageCur=='my'?'_cur':''] + '.png'"></image>
				</view>
				<view :class="PageCur=='cooperation'?'text-green':'text-gray'">合作</view>
			</view>
			<!-- <view class="action" @click="NavChange" data-cur="basics">
				<view class='cuIcon-cu-image'>
					<image :src="'/static/tabbar/basics' + [PageCur=='basics'?'_cur':''] + '.png'"></image>
				</view>
				<view :class="PageCur=='basics'?'text-green':'text-gray'">实时数据</view>
			</view>
			<view class="action" @click="NavChange" data-cur="component">
				<view class='cuIcon-cu-image'>
					<image :src="'/static/tabbar/component' + [PageCur == 'component'?'_cur':''] + '.png'"></image>
				</view>
				<view :class="PageCur=='component'?'text-green':'text-gray'">控制</view>
			</view>
			<view class="action" @click="NavChange" data-cur="plugin">
				<view class='cuIcon-cu-image'>
					<image :src="'/static/tabbar/plugin' + [PageCur == 'plugin'?'_cur':''] + '.png'"></image>
				</view>
				<view :class="PageCur=='plugin'?'text-green':'text-gray'">我的</view>
			</view> -->
		</view>
	</view>
</template>

<script>
	export default {
		data() {
		return {
				PageCur: 'info'
			}
		},
		methods: {
			NavChange: function(e) {
				this.PageCur = e.currentTarget.dataset.cur
			},
			changePage(page){
				this.PageCur = page
			}
		}
	}
</script>

<style>
</style>
