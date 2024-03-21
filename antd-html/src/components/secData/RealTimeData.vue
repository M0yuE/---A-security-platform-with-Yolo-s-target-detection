<template>
    <a-layout class="main">
        <div class="query">
            <a-select :value="modularId" @change="modularChange" placeholder="选择模块" style="width: 150px;margin-right: 10px">
                <a-select-option :value="item.id" v-for="item in modularList" :key="item.id">
                    {{item.name }}
                </a-select-option>
            </a-select>
            <a-select :value="equipmentId" @change="equipmentChange" placeholder="选择设备" style="width: 150px;margin-right: 10px">
                <a-select-option :value="item.id" v-for="item in equipmentList" :key="item.id">
                    {{item.name }}
                </a-select-option>
            </a-select>
            <a-input-search
                placeholder="输入连接名查询"
                style="width: 200px"
                @search="onSearch"
                enterButton
                v-model="queryData.name"
            />
        </div>
        <div>
            <a-table :locale="{'emptyText':'暂无数据'}" :pagination="pagination" :loading="loading"
                     :columns="columns"
                     :dataSource="data">
            </a-table>
        </div>
    </a-layout>
</template>

<script>
    import {mapGetters} from 'vuex'
    import api from '@/api'

    const columns = [{
        title: 'id',
        dataIndex: 'id',
    }, {
        title: '数据项名',
        dataIndex: 'name',
    }, {
        title: '实时值',
        dataIndex: 'curData',
    }, {
        title: '设备名称',
        dataIndex: 'equipmentName',
    },{
        title: '读取时间',
        dataIndex: 'fetchTime',
    }]
    export default {
        data() {
            return {
                data: [],
                columns,
                loading: false,
                queryData: {
                    name: "",
                    page: 1,
                    limit: 10,
                },
                pagination: {
                    showSizeChanger: true,
                    total: 0,
                    current: 0,
                    showTotal: total => `共 ${total} 条数据`,
                    onChange: this.pageChange,
                    onShowSizeChange: (current, pageSize) => this.queryData.limit = pageSize
                },
                form: this.$form.createForm(this),
                labelCol: {
                    xs: {span: 24},
                    sm: {span: 7}
                },
                wrapperCol: {
                    xs: {span: 24},
                    sm: {span: 13}
                },
                typeVal: 1,
                modularList:[],
                originEquipemntList:[],
                equipmentList:[],
                modularId:0,
                equipmentId:0,
                socket: null,
                isSocketOpen:false,
                timer:null
            }
        },
        computed: {
            ...mapGetters(['color']),
        },
        mounted() {
            if (!this.isHasPermission()('secData.realTimeData.list')) {
                return
            }
            this.loadData();
            this.$http.post(api.realTimeData.modularsAndEquipments).then(res => {
                if(res.code == 0){
                    this.modularList = res.modulars
                    this.modularList.unshift({id:0,name:'全部模块'})
                    this.originEquipemntList = res.equipments
                    this.filterEquipmentList()
                }else{
                    this.$message.error(res.msg)
                }
                this.loading = false
            }).catch(err => {
                console.log(err)
            })
            this.initDataSocket()
        },
         beforeDestroy(){
             if(this.isSocketOpen){
                 this.socket.onclose = null
                 this.socket.close()
             }
             if(this.timer){
                 clearInterval(this.timer)
             }
         },
        methods: {
            ...mapGetters(['isHasPermission']),
            filterEquipmentList(){
                if(!this.modularId){
                    this.equipmentList = this.originEquipemntList
                }else{
                    this.equipmentList = this.originEquipemntList.filter(item => {
                        return item.modularId == this.modularId
                    })
                }
                if(this.equipmentList && this.equipmentList.length && this.equipmentList[0].id){
                    this.equipmentList.unshift({id:0,name:'全部设备'})
                }
            },
            modularChange(val){
                this.modularId = val
                this.equipmentId = 0
                this.filterEquipmentList()
            },
            equipmentChange(val){
                this.equipmentId = val
            },
            onSearch() {
                this.queryData.page = 1
                this.loadData()
            },
            pageChange(page) {
                this.queryData.page = page
                this.loadData()
            },
            loadData() {
                this.loading = true
                if(this.modularId){
                    this.queryData.modularId = this.modularId
                }
                if(this.equipmentId){
                    this.queryData.equipmentId = this.equipmentId
                }
                this.$http.post(api.realTimeData.list, this.queryData).then(res => {
                    if(res.code == 0){
                        this.data = res.page.list
                        this.pagination.total = res.page.totalCount
                        this.pagination.current = res.page.currPage
                    }else{
                        this.$message.error(res.msg)
                    }
                    this.loading = false
                }).catch(err => {
                    console.log(err)
                })
            },
            socketClose(){//手动关闭
                this.socket.onclose = null
                this.socket.close()
                this.isSocketOpen = false
                if(this.timer){
                    clearInterval(this.timer)
                }
            },
            initDataSocket(){
                if (!this.isHasPermission()('other.socket.dataSocket')) {
                    return
                }
                if(this.socket){
                    this.socket.onclose = null
                    this.socket.close()
                }
                let host = location.host
                let protocolO = location.protocol
                let protocol = protocolO.indexOf('s') != -1 ? 'wss' : 'ws'
                this.socket = new WebSocket(protocol+'://'+host+api.socket.dataWebsocket)
                this.socket.onopen = this.open
                this.socket.onerror = this.error
                this.socket.onmessage = this.getMessage
                this.socket.onclose = this.close
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
                this.openNotificationWithIcon('success','数据socket连接成功','这里将会提示设备实时数据！')
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
                    let secData = data.secData
                    for(let i in this.data){
                        if(this.data[i].id == secData.id){
                            this.data[i] = secData
                        }
                    }
                    let type = 'info'
                    let title = '接收设备['+secData.equipmentName + ']数据'
                    let result = secData.curData
                    if(secData.convertTo == 3){
                        result = result == 0 ? '关闭' : '开启'
                    }
                    let desc = secData.name + '值:' + result
                    this.openNotificationWithIcon(type,title,desc)
                    this.$forceUpdate()
                }
            },
            send() {
                this.socket.send(params)
            },
            close() {
                this.isSocketOpen = false
                if(this.timer){
                    clearInterval(this.timer)
                }
                this.timer = setInterval(() => {
                    this.initDataSocket()
                },2000)
            },
        }
    }
</script>
<style lang="less" scoped>
    .main {
        padding: 25px;
        background: #fff;

        .query {
            margin-bottom: 25px;

            .btn {
                margin-left: 10px;
            }
        }
    }
</style>
