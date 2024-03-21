<template>
    <a-layout class="main">
        <div class="query">
            <a-input-search
                placeholder="输入连接名查询"
                style="width: 200px"
                @search="onSearch"
                enterButton
                v-model="queryData.name"
            />
            <a-button class="btn" type="primary" v-if="isHasPermission()('connectEquipment.connect.write')" @click="addUser">新增
            </a-button>
            <a-button v-show="selectedRowKeys.length > 0 && isHasPermission()('connectEquipment.connect.delete')" class="btn"
                      type="danger" @click="deleteData">删除
            </a-button>
        </div>
        <div>
            <a-table :locale="{'emptyText':'暂无数据'}" :customRow="customRow" :pagination="pagination" :loading="loading"
                     :rowSelection="{selectedRowKeys: selectedRowKeys, onChange: onSelectChange}" :columns="columns"
                     :dataSource="data">
                <template slot="status" slot-scope="text">
                    <a-tag :color="text == 1 ? 'green' : 'red'">{{text == 1 ? '开启' : '关闭'}}</a-tag>
                </template>
                <template slot="single" slot-scope="text">
                    <a-tag :color="text == 1 ? 'green' : 'red'">{{text == 1 ? '单连接' : '多连接'}}</a-tag>
                </template>
                <template slot="type" slot-scope="text">
                    <a-tag :color="text == 1 ? 'green' : 'cyan'">{{text == 1 ? 'TCP' : text == 2 ? 'UDP' : ''}}</a-tag>
                </template>
                <template slot="upModularList" slot-scope="list">
                    <a-badge :count="list ? list.length : 0">
                        <a-button @click.stop="preViewModular(list)">查看</a-button>
                    </a-badge>
                </template>
                <template slot="control" slot-scope="text, record">
                    <a-tag :color="color" v-if="isHasPermission()('connectEquipment.connect.write')" @click.stop="update(record)">修改</a-tag>
                </template>
            </a-table>
        </div>
        <a-modal
            title="在线模块"
            :width="640"
            :visible="modularVisible"
            :maskClosable="false"
            @cancel="modularVisible = false"
        >
            <a-table :locale="{'emptyText':'暂无数据'}" :pagination="false" :columns="modularColumns" :dataSource="modularData"></a-table>
            <template slot="footer">
                <a-button key="submit" type="primary" @click="modularVisible = false">
                    确定
                </a-button>
            </template>
        </a-modal>
        <a-modal
            :title="form.getFieldValue('userId') ? '修改连接' : '添加连接'"
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
                        label="连接名称"
                        :labelCol="labelCol"
                        :wrapperCol="wrapperCol"
                    >
                        <a-input style="width: 100%" placeholder="输入连接名称"
                            v-decorator="['name', {rules: [{required: true, min:1, message: '请输入连接名称！'}]}]"/>
                        <a-input style="display: none" type="hidden" v-decorator="['id',{}]"/>
                    </a-form-item>
                    <a-form-item
                        label="连接端口"
                        :labelCol="labelCol"
                        :wrapperCol="wrapperCol"
                    >
                        <a-input-number placeholder="连接端口"
                            v-decorator="['port', {rules: [{required: true, message: '请输入连接端口！'}]}]"/>
                    </a-form-item>
                    <a-form-item
                        label="连接类型"
                        :labelCol="labelCol"
                        :wrapperCol="wrapperCol">
                        <a-input style="display: none" type="hidden" v-decorator="['type',{initialValue:1}]"/>
                        <a-radio-group :options="[{label:'TCP',value:1},{label:'UDP',value:2}]" @change="changeType"
                                       :value="typeVal"/>
                    </a-form-item>
                    <a-form-item
                        label="单连接"
                        :labelCol="labelCol"
                        :wrapperCol="wrapperCol">
                        <a-input style="display: none" type="hidden" v-decorator="['single',{initialValue:0}]"/>
                        <a-radio-group :options="[{label:'否',value:0},{label:'是',value:1}]" @change="changeSingle"
                                       :value="single"/>
                    </a-form-item>
                </a-form>
            </a-spin>
        </a-modal>
    </a-layout>
</template>

<script>
    import {mapGetters} from 'vuex'
    import api from '@/api'

    const columns = [{
        title: 'id',
        dataIndex: 'id',
    }, {
        title: '连接名',
        dataIndex: 'name',
    }, {
        title: '端口',
        dataIndex: 'port',
    }, {
        title: '状态',
        dataIndex: 'status',
        scopedSlots: {customRender: 'status'},
    },{
        title: '在线模块',
        dataIndex: 'upModularList',
        scopedSlots: {customRender: 'upModularList'},
    }, {
        title: '连接类型',
        dataIndex: 'type',
        scopedSlots: {customRender: 'type'},
    },{
        title: '单连接',
        dataIndex: 'single',
        scopedSlots: {customRender: 'single'},
    }, {
        title: '操作',
        dataIndex: 'control',
        scopedSlots: {customRender: 'control'},
    }]
    const modularColumns = [{
        title: 'id',
        dataIndex: 'id',
    }, {
        title: '模块名称',
        dataIndex: 'name',
    }, {
        title: '备注',
        dataIndex: 'remark',
    }, {
        title: '验证字符',
        dataIndex: 'verify',
    }]
    export default {
        data() {
            return {
                data: [],
                columns,
                modularColumns,
                modularData:[],
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
                modularVisible:false,
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
                single:0
            }
        },
        computed: {
            ...mapGetters(['color'])
        },
        mounted() {
            if (!this.isHasPermission()('connectEquipment.connect.list')) {
                return
            }
            this.loadData();
        },
        methods: {
            ...mapGetters(['isHasPermission']),
            preViewModular(list){
                if(!list || !list.length){
                    this.$message.info('无设备在线！')
                    return
                }
                this.modularData = list
                this.modularVisible = true
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
            changeSingle(e){
                let val = e.target.value
                this.form.setFieldsValue({'single': val})
                this.single = val
            },
            changeType(e) {
                let val = e.target.value
                this.form.setFieldsValue({'type': val})
                this.typeVal = val
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
                this.$http.post(api.connect.list, this.queryData).then(res => {
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
                        url: api.connect.saveOrUpdate,
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
                                url: api.connect.delete,
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
