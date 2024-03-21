<template>
    <div>
        <div class="query">
            <a-input-search
                placeholder="输入模块名查询"
                style="width: 200px;margin-right: 10px;margin-bottom: 20px"
                @search="onSearch"
                enterButton
                v-model="queryData.name"
            />
            <a-button style="margin-right: 10px" class="btn" type="primary" v-if="isHasPermission()('connectEquipment.equipment.modularWrite')" @click="addUser">新增
            </a-button>
            <a-button v-show="selectedRowKeys.length > 0 && isHasPermission()('connectEquipment.equipment.modularDelete')" class="btn"
                      type="danger" @click="deleteData">删除
            </a-button>
        </div>
        <div>
            <a-table :locale="{'emptyText':'暂无数据'}" :customRow="customRow" :pagination="pagination" :loading="loading"
                     :rowSelection="{selectedRowKeys: selectedRowKeys, onChange: onSelectChange}" :columns="columns"
                     :dataSource="data">
                <template slot="control" slot-scope="text, record">
                    <a-tag :color="color" v-if="isHasPermission()('connectEquipment.equipment.modularWrite')" @click.stop="update(record)">修改</a-tag>
                    <a-tag :color="color" @click.stop="goNextStep(1,record)">设备</a-tag>
                </template>
            </a-table>
        </div>
        <a-modal
            :title="form.getFieldValue('id') ? '修改设备' : '修改设备'"
            :width="640"
            :visible="visible"
            :confirmLoading="confirmLoading"
            :maskClosable="false"
            @ok="handleSubmit"
            @cancel="handleCancel"
        >
            <a-spin :spinning="confirmLoading">
                <a-form :form="form" autocomplete="off">
                    <a-form-item
                        label="模块"
                        :labelCol="labelCol"
                        :wrapperCol="wrapperCol"
                    >
                        <a-input style="width: 100%" placeholder="输入模块名称"
                                 v-decorator="['name', {rules: [{required: true, min:1, message: '请输入模块名称！'}]}]"/>
                        <a-input style="display: none" type="hidden" v-decorator="['id',{}]"/>
                    </a-form-item>
                    <a-form-item
                        label="选择连接"
                        :labelCol="labelCol"
                        :wrapperCol="wrapperCol"
                    >
                        <a-select @change="handleConnectChange" v-decorator="['connectId', {rules: [{required: true, message: '请选择连接！'}]}]">
                            <a-select-option :value="item.id" v-for="item in connectList" :key="item.id">
                                {{'['+item.port + '] : ' + item.name + ':[连接数' + item.connectCount + ']' }}
                            </a-select-option>
                        </a-select>
                    </a-form-item>
                    <a-form-item
                        label="备注"
                        :labelCol="labelCol"
                        :wrapperCol="wrapperCol"
                    >
                        <a-input placeholder="备注"
                                        v-decorator="['remark', {}]"/>
                    </a-form-item>
                    <a-form-item
                        label="查询间隔(ms)"
                        :labelCol="labelCol"
                        :wrapperCol="wrapperCol"
                    >
                        <a-input-number placeholder="查询间隔"
                                        v-decorator="['queryInterval', {initValue:2000,rules: [{required: true, message: '请输入查询间隔！'}]}]"/>
                    </a-form-item>
                    <a-form-item
                        label="指令间隔(ms)"
                        :labelCol="labelCol"
                        :wrapperCol="wrapperCol"
                    >
                        <a-input-number placeholder="指令间隔"
                                        v-decorator="['instructInterval', {initValue:1000,rules: [{required: true, message: '请输入指令间隔！'}]}]"/>
                    </a-form-item>
                    <a-form-item v-if="showVerify"
                        label="验证字符"
                        :labelCol="labelCol"
                        :wrapperCol="wrapperCol"
                    >
                        <a-input placeholder="验证字符"
                                 v-decorator="['verify', {rules: [{required: true, message: '请填写验证字符！'}]}]"/>
                    </a-form-item>
                </a-form>
            </a-spin>
        </a-modal>
    </div>
</template>

<script>
    import {mapGetters} from 'vuex'
    import api from '@/api'

    const columns = [{
        title: 'id',
        dataIndex: 'id',
    }, {
        title: '模块名称',
        dataIndex: 'name',
    }, {
        title: '备注',
        dataIndex: 'remark',
    }, {
        title: '连接名',
        dataIndex: 'connectName',
    },{
        title: '查询间隔',
        dataIndex: 'queryInterval',
    },{
        title: '指令间隔',
        dataIndex: 'instructInterval',
    }, {
        title: '验证字符',
        dataIndex: 'verify',
    }, {
        title: '操作',
        dataIndex: 'control',
        scopedSlots: {customRender: 'control'},
    }]
    export default {
        props:{
            goNext:{
                type:Function,
                default:null
            }
        },
        data(){
            return {
                data: [],
                columns,
                selectedRowKeys: [],
                selectedItems: [],
                loading: false,
                queryData: {
                    name: "",
                    page: 1,
                    limit: 10
                },
                pagination: {
                    showSizeChanger: true,
                    total: 0,
                    current: 0,
                    showTotal: total => `共 ${total} 条数据`,
                    onChange: this.pageChange,
                    onShowSizeChange: (current, pageSize) => this.queryData.limit = pageSize
                },
                visible: false,
                confirmLoading: false,
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
                connectList:[],
                showVerify:true,
            }
        },
        computed: {
            ...mapGetters(['color'])
        },
        mounted() {
            if (!this.isHasPermission()('connectEquipment.equipment.modularList')) {
                return
            }
            this.loadData();
            this.loadConnectList()
        },
        methods: {
            ...mapGetters(['isHasPermission']),
            loadConnectList(){
                this.$http.post(api.connect.listAll).then(res => {
                    if(res.code == 0){
                        this.connectList = res.list
                    }else{
                        this.$message.error(res.msg)
                    }
                }).catch(err => {
                    console.log(err)
                })
            },
            goNextStep(step,record){
                this.goNext(step,record)
            },
            handleConnectChange(id){
                for(let i in this.connectList){
                    if(id == this.connectList[i].id){
                        let connect = this.connectList[i]
                        if(connect.single == 1){
                            if(connect.connectCount > 0){
                                this.$message.warning('单连接只能有一个模块！')
                                setTimeout(() => {
                                    this.form.setFieldsValue({'connectId': null})
                                },0)
                                return
                            }
                            this.showVerify = false
                        }else{
                            this.showVerify = true
                        }
                    }
                }
            },
            customRow(record,index) {
                return {
                    on: {
                        click: () => {
                            let flag = false
                            let indeX
                            for (let i = 0; i < this.selectedRowKeys.length; i++) {
                                if (this.selectedRowKeys[i] == index) {
                                    flag = true
                                    indeX = i
                                    break
                                }
                            }
                            if (flag) {
                                this.selectedRowKeys.splice(indeX, 1)
                            } else {
                                this.selectedRowKeys.push(index)
                            }
                            for (let i = 0; i < this.selectedItems.length; i++) {
                                if (this.selectedItems[i].id == record.id) {
                                    flag = true
                                    index = i
                                    break
                                }
                            }
                            if (flag) {
                                this.selectedItems.splice(indeX, 1)
                            } else {
                                this.selectedItems.push(record)
                            }
                        }
                    }
                }
            },
            roleOnChange(item) {
                item.checked = !item.checked
                let arr = []
                this.options.forEach(val => {
                    if (val.checked) {
                        arr.push(val.roleId)
                    }
                })
                this.curSelect = arr
            },
            changeType(e) {
                let val = e.target.value
                this.form.setFieldsValue({'type': val})
                this.typeVal = val
            },
            handleChange(value, info) {
                this.curSelect = info.data.props
            },
            onSelectChange(selectedRowKeys, selectedItems) {
                this.selectedRowKeys = selectedRowKeys
                this.selectedItems = selectedItems
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
                this.$http.post(api.equipment.modularList, this.queryData).then(res => {
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
            update(record) {
                this.visible = true
                const {form: {setFieldsValue}} = this
                let that = this
                setTimeout(() => {
                    that.typeVal = record.type
                    setFieldsValue(record)
                }, 0)
            },
            addUser() {
                this.form.resetFields()
                this.visible = true
                for (let i in this.options) {
                    this.options[i].checked = false
                }
            },
            handleSubmit() {
                const {form: {validateFields}} = this
                this.confirmLoading = true
                validateFields((errors, values) => {
                    if(errors){
                        this.confirmLoading = false
                        return
                    }
                    this.$http({
                        url: api.equipment.modularSaveOrUpdate,
                        method: 'post',
                        headers: {
                            send: 'json'
                        },
                        data: values,
                    }).then(res => {
                        if (res.code == 0) {
                            this.loadData()
                            this.visible = false
                        } else {
                            this.$message.error(res.msg)
                        }
                        this.confirmLoading = false
                        this.loadConnectList()
                    }).catch(err => {
                        console.log(err)
                    })
                })
            },
            deleteData() {
                let arr = [];
                this.selectedItems.forEach(item => {
                    arr.push(item.id)
                })
                const self = this
                this.$confirm({
                    title: '删除操作！',
                    content: '您是否要删除选中项？',
                    okText: '确认',
                    okType: 'danger',
                    cancelText: '取消',
                    onOk() {
                        return new Promise((resolve, reject) => {
                            self.$http({
                                url: api.equipment.modularDelete,
                                method: 'post',
                                headers: {
                                    send: 'json'
                                },
                                data: arr
                            }).then(res => {
                                if (res.code == 0) {
                                    self.$message.success('删除成功！')
                                    self.selectedItems = []
                                    self.selectedRowKeys = []
                                    self.loadData()
                                    self.loadConnectList()
                                    resolve()
                                }else{
                                    self.$message.error(res.msg)
                                    reject()
                                }
                            })
                        }).catch(() => console.log('Oops errors!'));
                    },
                    onCancel() {
                    },
                });
            },
            handleCancel() {
                this.visible = false
            }
        }
    }
</script>

<style scoped>

</style>