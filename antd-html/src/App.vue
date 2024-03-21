<template>
    <a-locale-provider :locale="locale">
        <div id="app">
            <router-view/>
        </div>
    </a-locale-provider>
</template>

<script>
    import zhCN from 'ant-design-vue/lib/locale-provider/zh_CN'
    import {AppDeviceEnquire} from '@/utils/mixin'
    import api from '@/api'
    import {mapGetters,mapActions} from 'vuex'

    export default {
        mixins: [AppDeviceEnquire],
        data() {
            return {
                locale: zhCN,
                socket: null,
                isSocketOpen:false,
                timer:null
            }
        },
        provide(){
            return{
                initWebsocket:this.initSysSocket,
                socketClose:this.socketClose
            }
        },
        mounted() {
            setTimeout(() => {
                let userPerm = this.getPermission()
                if(!userPerm || !userPerm.length){
                    return
                }
                this.initSysSocket()
            },1000)
        },
        methods:{
            ...mapActions(['SetWarnCount']),
            ...mapGetters(['getPermission','isHasPermission']),
            getWarnMsg(){
                if(this.isHasPermission()('secData.warnMsg.list')){
                    this.$http.post(api.warnMsg.warnCount).then(res => {
                        if(res.code == 0){
                            this.SetWarnCount(res.count)
                        }else{
                            this.$message.error(res.msg)
                        }
                        this.loading = false
                    }).catch(err => {
                        console.log(err)
                    })
                }
            },
            socketClose(){//手动关闭
                this.socket.onclose = null
                this.socket.close()
                this.isSocketOpen = false
                if(this.timer){
                    clearInterval(this.timer)
                }
            },
            initSysSocket(){
                this.getWarnMsg()
                if (!this.isHasPermission()('other.socket.sysSocket')) {
                    return
                }
                if(this.socket){
                    this.socket.onclose = null
                    this.socket.close()
                }
                let host = location.host
                let protocolO = location.protocol
                let protocol = protocolO.indexOf('s') != -1 ? 'wss' : 'ws'
                this.socket = new WebSocket(protocol+'://'+host+api.socket.sysWebsocket)
                this.socket.onopen = this.open
                this.socket.onerror = this.error
                this.socket.onmessage = this.getMessage
                this.socket.onclose = this.close
            },
            alertDataWarn(title,msg){
                this.$notification['warning']({
                    message: title,
                    description: msg,
                    placement:'bottomRight',
                    duration: 0,
                    btn: h => {
                        return h(
                            'a-button',
                            {
                                props: {
                                    type: 'primary',
                                    size: 'small',
                                },
                                on: {
                                    click: () => this.$notification.destroy(),
                                },
                            },
                            '关闭全部',
                        );
                    },
                });
            },
            openNotificationWithIcon(type,title,desc) {
                this.$notification[type]({
                    message: title,
                    description: desc,
                });
            },
            open() {
                this.isSocketOpen = true
                if(this.timer){
                    clearInterval(this.timer)
                }
                this.openNotificationWithIcon('success','系统socket连接成功','这里将会提示设备上下线，警告信息，设备信息等消息！')
            },
            error() {
                console.log("连接错误")
                if(this.timer){
                    clearInterval(this.timer)
                }
            },
            getMessage(msg) {
                let data = JSON.parse(msg.data)
                if(data.type == 1){
                    let type = 'success'
                    let title = '上线'
                    let desc = '系统将会自动发送查询指令！'
                    if(!data.modular.isUp){
                        type = 'warning'
                        title = '下线'
                        desc = '系统将会停止发送指令！'
                    }
                    this.openNotificationWithIcon(type,data.modular.name + title,desc)
                }else if(data.type == 2){
                    let secData = data.secData
                    let title = secData.equipmentName + "设备的"+secData.name + "数据异常"
                    let msg = data.warnMsg.msg
                    this.alertDataWarn(title,msg)
                    this.getWarnCount()
                }
            },
            send() {
                this.socket.send(params)
            },
            getWarnCount(){
                this.$http.post(api.warnMsg.warnCount).then(res => {
                    if(res.code == 0){
                        this.SetWarnCount(res.count)
                    }else{
                        this.$message.error(res.msg)
                    }
                    this.loading = false
                }).catch(err => {
                    console.log(err)
                })
            },
            close() {
                this.isSocketOpen = false
                if(this.timer){
                   clearInterval(this.timer)
                }
                this.timer = setInterval(() => {
                    this.initSysSocket()
                },2000)
            },
        }
    }
</script>
<style>
    #app {
        height: 100%;
    }
</style>
