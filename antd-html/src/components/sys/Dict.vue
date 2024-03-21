<template>
    <a-layout class="main">
        <div class="query">
            <a-input-search
                placeholder="输入名称"
                style="width: 200px"
                @search="onSearch"
                enterButton
                v-model="queryData.name"
            />
            <a-button class="btn" type="primary" v-if="isHasPermission()('sys.dict.save')" @click="addJob">新增</a-button>
            <a-button v-show="selectedRowKeys.length > 0 && isHasPermission()('sys.dict.delete')" class="btn"
                      type="danger" @click="deleteData">删除
            </a-button>
        </div>
        <div>
            <a-table :locale="{'emptyText':'暂无数据'}" :customRow="customRow" :pagination="pagination" :loading="loading"
                     :rowSelection="{selectedRowKeys: selectedRowKeys, onChange: onSelectChange}" :columns="columns"
                     :dataSource="data">
                <template slot="control" slot-scope="text, record">
                    <a-tag :color="color" v-if="isHasPermission()('sys.dict.update')" @click.stop="update(record)">修改
                    </a-tag>
                </template>
            </a-table>
        </div>
        <a-modal
            :title="form.getFieldValue('id') ? '修改字典管理' : '添加字典管理'"
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
                        label="字典名称"
                        :labelCol="labelCol"
                        :wrapperCol="wrapperCol">
                        <a-input
                            v-decorator="['name',  {rules: [{ required: true, message: '请输入字典名称' }], validateTrigger: 'blur'}]"/>
                        <a-input style="display: none" type="hidden" v-decorator="['id']"/>
                    </a-form-item>
                    <a-form-item
                        label="字典类型"
                        :labelCol="labelCol"
                        :wrapperCol="wrapperCol">
                        <a-input
                            v-decorator="['type',  {rules: [{ required: true, message: '请输入字典类型' }], validateTrigger: 'blur'}]"
                        />
                    </a-form-item>
                    <a-form-item
                        label="字典码"
                        :labelCol="labelCol"
                        :wrapperCol="wrapperCol">
                        <a-input
                            v-decorator="['code',  {rules: [{ required: true, message: '请输入字典码' }], validateTrigger: 'blur'}]"
                        />
                    </a-form-item>
                    <a-form-item
                        label="字典值"
                        :labelCol="labelCol"
                        :wrapperCol="wrapperCol">
                        <a-input
                            v-decorator="['value',  {rules: [{ required: true, message: '请输入字典值' }], validateTrigger: 'blur'}]"
                        />
                    </a-form-item>
                    <a-form-item
                        label="排序"
                        :labelCol="labelCol"
                        :wrapperCol="wrapperCol">
                        <a-input-number
                            v-decorator="['orderNum', {rules: [{ required: true, message: '请输入排序值' }], validateTrigger: 'blur'}]"
                        />
                    </a-form-item>
                    <a-form-item
                        label="备注"
                        :labelCol="labelCol"
                        :wrapperCol="wrapperCol">

                        <a-input v-decorator="['remark']"
                        />
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
        dataIndex: 'id'
    }, {
        title: '名称',
        dataIndex: 'name'
    }, {
        title: '字典类型',
        dataIndex: 'type'
    }, {
        title: '字典码',
        dataIndex: 'code'
    }, {
        title: '字典值',
        dataIndex: 'value'
    }, {
        title: '排序',
        dataIndex: 'orderNum'
    }, {
        title: '备注',
        dataIndex: 'remark'
    }, {
        title: '操作',
        dataIndex: 'control',
        scopedSlots: {customRender: 'control'}
    }
    ]

    export default {
        data() {
            return {
                data: [],
                columns,
                selectedRowKeys: [],
                selectedItems: [],
                loading: false,
                queryData: {
                    name: '',
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
                curSelect: [],
                options: []
            }
        },
        computed: {
            ...mapGetters(['color'])
        },
        mounted() {
            if (!this.isHasPermission()('sys.dict.list')) {
                return
            }
            this.loadData()//加载数据
        },
        methods: {
            ...mapGetters(['isHasPermission']),
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
                this.$http.post(api.dict.list, this.queryData).then(res => {
                    if(res.code == 0){
                        /*获取页面返回的数据*/
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
            addJob() {
                this.form.resetFields()
                this.visible = true
            },
            update(record) {
                this.visible = true
                const {form: {setFieldsValue}} = this
                setTimeout(() => {
                    setFieldsValue(record)
                }, 0)
            },
            handleSubmit() {
                /*表单验证*/
                const {form: {validateFields}} = this
                this.confirmLoading = true
                validateFields((errors, values) => {
                    let url = values.id == null ? api.dict.save : api.dict.update
                    if (!errors) {
                        this.$http({
                            url: url,
                            method: 'post',
                            headers: {
                                send: 'json'
                            },
                            data: values
                        }).then(res => {
                            if(res.code == 0){
                                /*新增 修改的model*/
                                this.visible = false
                                this.addOrUpdateHtmlData(res.result);
                            }else{
                                this.$message.error(res.msg)
                            }
                            /*加载动画*/
                            this.confirmLoading = false
                        }).catch(err => {
                            console.log(err)
                        })
                    } else {
                        this.confirmLoading = false
                    }
                })
            },
            deleteData() {
                let arr = []
                this.selectedItems.forEach(item => {
                    arr.push(item.id)
                })
                if (arr.length < 1) {
                    this.$message.error('请最少选则一条数据操作')
                }
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
                                url: api.dict.deleteBatch,
                                method: 'post',
                                headers: {
                                    send: 'json'
                                },
                                data: arr
                            }).then(res => {
                                if(res.code == 0){
                                    self.$message.success('删除成功！')
                                    for (let i in self.selectedItems) {
                                        self.deleteHtmlData(self.selectedItems[i], self.data)
                                    }
                                    self.selectedRowKeys.length = 0
                                    resolve()
                                }else{
                                    self.$message.error(res.msg)
                                    reject()
                                }
                            })
                        }).catch((e) => console.log(e))
                    },
                    onCancel() {
                    }
                })
            },
            deleteHtmlData(targetData) {
                let indexOf = this.indexOf(targetData, this.data, 'id')
                if (indexOf != -1) {
                    this.pagination.total = this.pagination.total - this.selectedItems.length;
                    this.data.splice(indexOf, 1)

                }
                if (this.data.length == 0) {
                    this.loadData()
                }
            },
            addOrUpdateHtmlData(targetData) {
                let indexOf = this.indexOf(targetData, this.data, 'id')
                if (indexOf != -1) {
                    this.data[indexOf] = targetData
                    this.$message.success('修改成功！')
                } else {
                    this.data = [targetData].concat(this.data);
                    this.pagination.total = this.pagination.total + 1;
                    this.$message.success('添加成功！')
                }
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
