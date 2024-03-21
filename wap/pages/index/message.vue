<template>
	<view>
		<!-- <view class="status_bar" :style="{height:barHeight + 'px',width:'100%'}"></view>
		<view style="height: 80rpx;text-align: center;border-bottom: 1px dashed #ccc;line-height: 80rpx;">
			<view style="display:inline-block;margin-left: 30rpx;">预警消息(左滑操作)</view>
		</view> -->
		<cu-custom bgColor="White" :isBack="false">
			<block slot="content">预警消息(左滑操作)</block>
		</cu-custom>
		<view class="cu-list menu-avatar">
			<view class="cu-item" :class="modalName=='move-box-'+ item.id?'move-cur':''" v-for="item in messages" :key="item.id"
			 @touchstart="ListTouchStart" @touchmove="ListTouchMove" @touchend="ListTouchEnd" :data-target="'move-box-' + item.id">
				<view class="content" @click="prew(item)">
					<view class="text-grey">{{item.equipmentName + '->' + item.dataName}}</view>
					<view class="text-gray text-sm text-break-dian">
						{{item.msg}}
					</view>
				</view>
				<view class="action">
					<view class="text-grey text-xs">{{item.createTime.substring(11,16)}}</view>
					<view :class="['cu-tag','round',item.isRead ? 'bg-green' : 'bg-red','sm']">{{item.isRead ? '已读' : '未读'}}</view>
				</view>
				<view class="move">
					<view class="bg-grey" @click="read(item.id)" v-if="!item.isRead">标记已读</view>
					<view class="bg-red" @click="deleteWarnMsg(item.id)">删除</view>
				</view>
			</view>
		</view>
		<view class="cu-modal" :class="show ? 'show' : ''">
			<view class="cu-dialog">
				<view class="cu-bar bg-white justify-end">
					<view class="content">{{curMes.dataName}}</view>
					<view class="action" @tap="hideModal">
						<text class="cuIcon-close text-red"></text>
					</view>
				</view>
				<view class="padding-xl">
					{{curMes.msg}}
				</view>
			</view>
		</view>
	</view>
</template>

<script>
	export default {
		data() {
			return {
				barHeight:0,
				modalName: null,
				listTouchStart: 0,
				listTouchDirection: null,
				show:false,
				curMes:{},
				messages:[],
			}
		},
		mounted() {
			let info = uni.getSystemInfoSync()
			this.barHeight = info.statusBarHeight
			this.setRealWarnMsg();
		},
		methods: {
			setRealWarnMsg(){
				this.http.get(this.api.warnMsg).then(res => {
					if(res.code == 0){
						this.$data.messages = res.messages
					}
					this.loading = true
				}).catch(e => {
					uni.showToast({ title:JSON.stringify(e), icon: "none" });
				})
			}, 
			prew(item){
				this.curMes = item
				this.show = true
			},
			hideModal(e) {
				this.show = false
			},
			read(id){
				 let warnMsgReadId = {id:id}
				 this.http.put(this.api.warnMsgRead,warnMsgReadId).then(res => {
				 	if(res.code == 0){
				 		uni.showToast({title:"信息已读",icon:"success"})
						this.$data.messages = res.messages
				 	}else{
						uni.showToast({title:"标记异常",icon:"loading"})
					}
				 	this.loading = true
				 }).catch(e => {
				 	uni.showToast({ title:JSON.stringify(e), icon: "none" });
				 })
			},
			deleteWarnMsg(id){
				let warnMsgDeleteId = {id:id}
				this.http.put(this.api.warnMsgDelete,warnMsgDeleteId).then(res =>{
					if(res.code == 0){
						uni.showToast({title:"删除成功",icon:"success"})
						this.$data.messages = res.messages
					}else{
						uni.showToast({title:"删除异常",icon:"loading"})
					}
					this.loading = false
				}).catch(e => {
					uni.showToast({title:JSON.stringify(e),icon:"none"});
				})
			},
			ListTouchStart(e) {
				this.listTouchStart = e.touches[0].pageX
			},
			ListTouchMove(e) {
				this.listTouchDirection = e.touches[0].pageX - this.listTouchStart > 0 ? 'right' : 'left'
			},
			ListTouchEnd(e) {
				if (this.listTouchDirection == 'left') {
					this.modalName = e.currentTarget.dataset.target
				} else {
					this.modalName = null
				}
				this.listTouchDirection = null
			}
		}
	}
</script>

<style>
	.content{
		left: 30rpx !important;
		width: calc(100% - 52px - 32px) !important;
	}
	.text-break-dian{
		word-break: break-all;  /* break-all(允许在单词内换行。) */
		text-overflow: ellipsis;  /* 超出部分省略号 */
		display: -webkit-box; /** 对象作为伸缩盒子模型显示 **/
		-webkit-box-orient: vertical; /** 设置或检索伸缩盒对象的子元素的排列方式 **/
		-webkit-line-clamp: 1; /** 显示的行数 **/
		overflow: hidden;
	}
</style>
