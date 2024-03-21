<template>
    <div>
        <div class="query">
            <a-input-search
                placeholder="输入指令名查询"
                style="width: 200px;margin-right: 10px;margin-bottom: 20px"
                @search="onSearch"
                enterButton
                v-model="queryData.name"
            />
            <a-button style="margin-right: 10px" class="btn" type="primary" v-if="isHasPermission()('connectEquipment.equipment.instructWrite')" @click="addUser">新增
            </a-button>
            <a-button v-show="selectedRowKeys.length > 0 && isHasPermission()('connectEquipment.equipment.instructDelete')" class="btn"
                      type="danger" @click="deleteData">删除
            </a-button>
        </div>
        <div>
            <a-table :locale="{'emptyText':'暂无数据'}" :customRow="customRow" :pagination="pagination" :loading="loading"
                     :rowSelection="{selectedRowKeys: selectedRowKeys, onChange: onSelectChange}" :columns="columns"
                     :dataSource="data">
                <template slot="type" slot-scope="text">
                    <a-tag :color="text == 0 ? 'green' : 'red'">{{text == 0 ? '状态指令' : '控制指令'}}</a-tag>
                </template>
                <template slot="control" slot-scope="text, record">
                    <a-tag :color="color" v-if="isHasPermission()('connectEquipment.equipment.instructWrite')" @click.stop="update(record)">修改</a-tag>
                    <a-tag :color="color" @click.stop="goNextStep(3,record)">数据项</a-tag>
                    <a-popconfirm  v-if="isHasPermission()('connectEquipment.equipment.sendInstruct') && record.type"
                        :title="'确定要下发['+record.name+']指令？'"
                        ok-text="确定"
                        cancel-text="取消"
                        @confirm="sendInstruct(record)"
                    >
                        <a-button size="small" @click.stop="() => {}" type="primary" :loading="record.loading" style="font-size:12px;height: 22px">下发</a-button>
                    </a-popconfirm>
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
                        label="指令名称"
                        :labelCol="labelCol"
                        :wrapperCol="wrapperCol"
                    >
                        <a-input style="width: 100%" placeholder="输入指令名称"
                                 v-decorator="['name', {rules: [{required: true, min:1, message: '请输入设备名称！'}]}]"/>
                        <a-input style="display: none" type="hidden" v-decorator="['id',{}]"/>
                    </a-form-item>
                    <a-form-item
                        label="指令"
                        :labelCol="labelCol"
                        :wrapperCol="wrapperCol"
                    >
                        <a-input style="width: 100%" placeholder="输入设备指令"
                                 v-decorator="['instruct', {rules: [{required: true, min:1, message: '请输入设备指令！'}]}]"/>
                    </a-form-item>
                    <a-form-item
                        label="返回示例"
                        :labelCol="labelCol"
                        :wrapperCol="wrapperCol"
                    >
                        <a-input style="width: 100%" placeholder="输入返回示例"
                                 v-decorator="['retExample', {rules: [{required: true, min:1, message: '请输入返回示例！'}]}]"/>
                    </a-form-item>
                    <a-form-item
                        label="指令类型"
                        :labelCol="labelCol"
                        :wrapperCol="wrapperCol">
                        <a-input style="display: none" type="hidden" v-decorator="['type',{initialValue:0}]"/>
                        <a-radio-group :options="[{label:'读指令',value:0},{label:'写指令',value:1}]" @change="changeType"
                                       :value="type"/>
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
        title: '指令名称',
        dataIndex: 'name',
    }, {
        title: '指令',
        dataIndex: 'instruct',
    }, {
        title: '返回示例',
        dataIndex: 'retExample',
    }, {
        title: '设备名',
        dataIndex: 'equipmentName',
    }, {
        title: '指令类型',
        dataIndex: 'type',
        scopedSlots: {customRender: 'type'},
    },{
        title: '操作',
        dataIndex: 'control',
        scopedSlots: {customRender: 'control'},
    }]
    export default {
        props:{
            goNext:{
                type:Function,
                default:null
            },
            pid:{
                type:Number,
                default:0
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
                type: 0,
            }
        },
        computed: {
            ...mapGetters(['color'])
        },
        mounted() {
            if (!this.isHasPermission()('connectEquipment.equipment.instructList')) {
                return
            }
            this.loadData();
        },
        methods: {
            ...mapGetters(['isHasPermission']),
            sendInstruct(record){
                record.loading = true
                this.$http.post(api.equipment.sendInstruct,{id:record.id}).then(res => {
                    if(res.code == 0){
                        this.$message.success(res.msg)
                    }else{
                        this.$message.error(res.msg)
                    }
                    record.loading = false
                }).catch(err => {
                    console.log(err)
                })

            },
            goNextStep(step,record){
                this.goNext(step,record)
            },
            handleConnectChange(){
                console.log(arguments)
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
                this.type = val
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
                this.queryData.pid = this.pid
                this.$http.post(api.equipment.instructList, this.queryData).then(res => {
                    if(res.code == 0){
                        this.data = res.page.list.map(item => {
                            item.loading = false
                            return item
                        })
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
                    values.equipmentId = this.pid
                    this.$http({
                        url: api.equipment.instructSaveOrUpdate,
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
                                url: api.equipment.instructDelete,
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
                                    resolve()
                                }else{
                                    this.$message.error(res.msg)
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