  <template>
 	<view>
 		<cu-custom bgColor="White" :isBack="false">
 			<block slot="content">实时数据</block>
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
			 				<view class="content">
			 					<view class="text-grey">{{ite.name}}</view>
			 					<view class="text-gray text-sm flex">
			 						<text class="text-cut">
			 							{{ite.fetchTime}}
			 						</text> 
			 					</view>
			 				</view>
			 				<view class="action">
			 					<view class="text-grey text-xs" style="font-weight: bold;color: black;font-size: 20rpx">{{ite.curData}}</view>
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
				let info = uni.getSystemInfoSync()
				this.barHeight = info.statusBarHeight
				// 页面加载时调用封装好的Ajax请求，请求后端传递来的数据
				this.setRealData()	
		},
		methods: {
			setRealData(){
				this.http.get(this.api.realData).then(res => {
					if(res.code == 0){
						this.$data.modulars = res.Modular
					}
					this.loading = true
				}).catch(e => {
					uni.showToast({ title: JSON.stringify(e), icon: "none" });
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
</style>
