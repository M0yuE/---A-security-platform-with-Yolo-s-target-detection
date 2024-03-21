<template>
	<view class="content">
		<!-- <view class="status_bar" :style="{height:barHeight + 'px',width:'100%'}"></view>
		<view style="height: 80rpx;text-align: center;border-bottom: 1px dashed #ccc;line-height: 80rpx;">
			智慧安防平台
		</view> -->
		<cu-custom bgColor="White" :isBack="false">
			<block slot="content">智慧安防平台</block>
		</cu-custom>
		<swiper class="card-swiper" :class="dotStyle?'square-dot':'round-dot'" :indicator-dots="true" :circular="true"
		 :autoplay="true" interval="5000" duration="500" @change="cardSwiper" indicator-color="#8799a3"
		 indicator-active-color="#0081ff">
			<swiper-item v-for="(item,index) in swiperList" :key="index" :class="cardCur==index?'cur':''">
				<view class="swiper-item" style="border:1px dashed #ccc">
					<image :src="item.url" mode="aspectFill" v-if="item.type=='image'"></image>
					<video :src="item.url" autoplay loop muted :show-play-btn="false" :controls="false" objectFit="cover" v-if="item.type=='video'"></video>
				</view>
			</swiper-item>
		</swiper>
		<view class="cu-list grid" :class="['col-' + gridCol,'no-border']">
			<view class="cu-item" v-for="(item,index) in cuIconList" :key="index" v-if="index<gridCol*2" @click="changePage(item.page)">
				<image mode="aspectFill" style="width: 60rpx;height: 60rpx;margin: auto;" :src="item.url">
					<view class="cu-tag badge" v-if="item.badge!=0">
						<block v-if="item.badge!=1">{{item.badge>99?'99+':item.badge}}</block>
					</view>
				</image>
				<text>{{item.name}}</text>
			</view>
		</view>
		<!-- <scroll-view scroll-x class="bg-white nav" scroll-with-animation :scroll-left="scrollLeft">
			<view class="cu-item" :class="index==TabCur?'text-green cur':''" v-for="(item,index) in 10" :key="index" @tap="tabSelect" :data-id="index">
				Tab{{index}}
			</view>
		</scroll-view> -->
	</view>
</template>

<script>
	export default{
		data(){
			return {
				barHeight:0,
				cuIconList: [{
					cuIcon: 'cardboardfill',
					color: 'red',
					badge: 0,
					name: '实时数据',
					page:'data',
					url:'/static/info-btn/data.png'
				}, {
					cuIcon: 'recordfill',
					color: 'orange',
					badge: 0,
					name: '控制中心',
					page:'control',
					url:'/static/info-btn/control.png'
				}, {
					cuIcon: 'picfill',
					color: 'yellow',
					badge: 30,
					name: '警告消息',
					page:'message',
					url:'/static/info-btn/message.png'
				}, {
					cuIcon: 'noticefill',
					color: 'olive',
					badge: 0,
					name: '个人中心',
					page:'my',
					url:'/static/info-btn/person.png'
				}, {
					cuIcon: 'upstagefill',
					color: 'cyan',
					badge: 0,
					name: '关于我们',
					page:'about',
					url:'/static/info-btn/about.png'
				}, {
					cuIcon: 'clothesfill',
					color: 'blue',
					badge: 0,
					name: '合作',
					page:'cooperation',
					url:'/static/info-btn/cooperation.png'
				}],
				gridCol: 3,
				TabCur: 0,
				scrollLeft: 0,
				cardCur: 0,
				swiperList: [{
					id: 0,
					type: 'image',
					url: '/static/swipper/1.png'
				}, {
					id: 1,
					type: 'image',
					url: '../../static/swipper/2.png',
				}, {
					id: 2,
					type: 'image',
					url: '../../static/swipper/3.png'
				}, {
					id: 3,
					type: 'image',
					url: '../../static/swipper/4.png'
				}, {
					id: 4,
					type: 'image',
					url: '../../static/swipper/5.png'
				}, {
					id: 5,
					type: 'image',
					url: '../../static/swipper/6.png'
				}],
				dotStyle: false,
				towerStart: 0,
				direction: ''
			}
		},
		mounted() {
			let info = uni.getSystemInfoSync()
			this.barHeight = info.statusBarHeight
		},
		methods:{
			tabSelect(e) {
				this.TabCur = e.currentTarget.dataset.id;
				this.scrollLeft = (e.currentTarget.dataset.id - 1) * 60
			},
			cardSwiper(e) {
				this.cardCur = e.detail.current
			},
			changePage(page){
				if(page){
					this.$emit("changePage",page)
				}
			}
		}
	}
</script>

<style>
	.content{
		display: flex;
		flex-direction: column;
		justify-content: center;
	}
</style>
