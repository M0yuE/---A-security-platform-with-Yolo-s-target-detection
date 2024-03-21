<template>
	<view>
		<!-- <view class="status_bar" :style="{height:barHeight + 'px',width:'100%'}"></view>
		<view style="height: 80rpx;text-align: center;border-bottom: 1px dashed #ccc;line-height: 80rpx;">
			控制中心
		</view> -->
		<cu-custom bgColor="White" :isBack="false">
			<block slot="content">控制中心</block>
		</cu-custom>
		<view class="VerticalBox">
			<scroll-view class="VerticalNav nav" scroll-y scroll-with-animation :scroll-top="verticalNavTop" style="height:calc(100vh - 200upx)">
				<view class="cu-item" :class="item.id==tabCur?'text-green cur':''" v-for="item in modulars" :key="item.id" @tap="TabSelect"
				 :data-id="item.id">
					{{item.name}}
				</view>
			</scroll-view>
			<scroll-view class="VerticalMain" scroll-y scroll-with-animation style="height:calc(100vh - 200upx)"
			 :scroll-into-view="'main-'+mainCur" @scroll="VerticalMain">
				<view v-for="items in modulars" :key="items.id" :id="'main-'+items.id">
					<view class="text-center padding-top">
						<text class="text-bold">{{items.name}}</text>
					</view>
					<view class="padding-top padding-lr" v-for="item in items.equipments" :key="item.id" :id="item.id">
						<view class="cu-bar solid-bottom bg-white">
							<view class="action">
								<text class="cuIcon-title text-green"></text> {{item.name}}</view>
						</view>
						<view class="cu-list menu-avatar">
							<view class="cu-item" v-for="ite in item.datas" :key="ite.id">
								<view class="content content_customer">
									<view class="text-grey">{{ite.name}}</view>
									<view class="text-gray text-sm flex">
										<text class="text-cut">
											{{ite.fetchTime}}
										</text> 
									</view>
								</view>
								<view class="action action_customer">
									<!-- <view class="text-grey text-xs" style="font-weight: bold;font-size: 20rpx">红外状态</view> -->
									<view class="text-grey text-xs" style="font-weight: bold;font-size: 20rpx">{{ite.name}}</view>
									<view class="text-grey text-xs" style="font-weight: bold;font-size: 20rpx">{{ite.curData}}</view>
								</view>
								<view class="action action_customer">
									<button class="send-btn cu-btn lines-green" @click="uniSendInstruct(ite.id)">下发</button>
								</view>
							</view>
						</view>
					</view>
				</view>
			</scroll-view>
		</view>
	</view>
</template>

<script>
	export default {
		data() {
			return {
				list: [],
				tabCur: 0,
				mainCur: 0,
				verticalNavTop: 0,
				load: true,
				barHeight:0,
				modulars:[],
			};
		},
		mounted() {
			let info = uni.getSystemInfoSync();
			this.barHeight = info.statusBarHeight;
			
			//赋值数据
			this.setRealData()
			
			// uni.showLoading({
			// 	title: '加载中...',
			// 	mask: true
			// });
			
			
			// let list = [{}];
			// for (let i = 0; i < 26; i++) {
			// 	list[i] = {};
			// 	list[i].name = String.fromCharCode(65 + i);
			// 	list[i].id = i;
			// }
			// this.list = list;
			// this.listCur = list[0];
		},
		methods: {
			setRealData(){
				// uni.showLoading({
				// 	title:'加载中...',
				// 	mask:true
				// })
				this.http.get(this.api.controlData).then(res => {
					if(res.code == 0){
						this.$data.modulars = res.Modular
					}
					this.loading = true
					
					
				}).catch(e => {
					uni.showToast({ title: JSON.stringify(e), icon: "none" });
				})
			}, 
			// setRealData(){
			// 	uni.showLoading({
			// 		title:'加载中...',
			// 		mask:true
			// 	})
			// 	this.http.get(this.api.realData).then(res => {
			// 		if(res.code == 0){
			// 			this.$data.equipments = res.Equipment
			// 		}
			// 		this.loading = true
			// 	}).catch(e => {
			// 		uni.showToast({title: JSON.stringify(e),icon:"none"})
			// 	}).success(res => {
			// 		setTimeout(function () {uni.hideLoading();}, 100);
			// 	})
			// },
			//下发函数
			uniSendInstruct(id){	//向后端传数据项ID
				let sendInstructId = {id:id}
				this.http.post(this.api.sendInstruct,sendInstructId).then(res => {
					if(res.code == 0){
						this.$data.modulars = res.Modular
						uni.showToast({title:"下发成功",icon:"none"})
					}else if(res.code == 500){
						uni.showToast({title:"设备未连接云平台，请先确认连接",icon:"none"})
					}
					this.loading = true
				}).catch(e => {
					uni.showToast({title:JSON.stringify(e),icon:"none"});
				})
			},
				
			
			TabSelect(e) {
				this.tabCur = e.currentTarget.dataset.id;
				this.mainCur = e.currentTarget.dataset.id;
				this.verticalNavTop = (e.currentTarget.dataset.id - 1) * 50
			},
			VerticalMain(e) {
				// #ifdef MP-ALIPAY
				   return false  //支付宝小程序暂时不支持双向联动
				// #endif
				let that = this;
				let tabHeight = 0;
				if (this.load) {
					for (let i = 0; i < this.list.length; i++) {
						let view = uni.createSelectorQuery().select("#main-" + this.list[i].id);
						view.fields({
							size: true
						}, data => {
							this.list[i].top = tabHeight;
							tabHeight = tabHeight + data.height;
							this.list[i].bottom = tabHeight;
						}).exec();
					}
					this.load = false
				}
				let scrollTop = e.detail.scrollTop + 10;
				for (let i = 0; i < this.list.length; i++) {
					if (scrollTop > this.list[i].top && scrollTop < this.list[i].bottom) {
						this.verticalNavTop = (this.list[i].id - 1) * 50
						this.tabCur = this.list[i].id
						console.log(scrollTop)
						return false
					}
				}
			}
		},
	}
</script>

<style>
	.fixed {
		position: fixed;
		z-index: 99;
	}

	.VerticalNav.nav {
		width: 200upx;
		white-space: initial;
	}

	.VerticalNav.nav .cu-item {
		width: 100%;
		text-align: center;
		background-color: #fff;
		margin: 0;
		border: none;
		height: auto;
		position: relative;
	}

	.VerticalNav.nav .cu-item.cur {
		background-color: #f1f1f1;
	}

	.VerticalNav.nav .cu-item.cur::after {
		content: "";
		width: 8upx;
		/* height: 30upx; */
		height: 35%;
		border-radius: 10upx 0 0 10upx;
		position: absolute;
		background-color: currentColor;
		top: 0;
		right: 0upx;
		bottom: 0;
		margin: auto;
	}

	.VerticalBox {
		display: flex;
	}

	.VerticalMain {
		background-color: #f1f1f1;
		flex: 1;
	}
	.cu-list.menu-avatar>.cu-item .content{
		left: 30rpx;
		width: calc(100% - 96upx - 30upx);
	}
	.content_customer{
		width: calc(100% - 250upx) !important;
	}
	.send-btn{
		width: 80rpx;
		height:60rpx;
		font-size:16rpx;
		padding: 0;
	}
</style>
