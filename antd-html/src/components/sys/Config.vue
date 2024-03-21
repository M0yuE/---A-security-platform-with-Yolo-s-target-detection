<template>
    <a-layout class="main">
        <div class="query">
            <a-input-search
                placeholder="输入参数查询"
                style="width: 200px"
                @search="onSearch"
                enterButton
                v-model="queryData.paramKey"
            />&nbsp;&nbsp;
            <a-button class="btn" type="primary" v-if="isHasPermission()('sys.config.save')" @click="addConfig">新增
            </a-button
            >&nbsp;&nbsp;
            <a-button
                v-show="selectedRowKeys.length > 0 && isHasPermission()('sys.config.delete')"
                class="btn"
                type="danger"
                @click="deleteData"
            >删除
            </a-button
            >
        </div>
        <div>
            <a-table
                :locale="{ emptyText: '暂无数据' }"
                :pagination="pagination"
                :loading="loading"
                :rowSelection="{ selectedRowKeys: selectedRowKeys, onChange: onSelectChange }"
                :columns="columns"
                :dataSource="data"
                class="ant-table"
                :customRow="customRow"
            >
                <template slot="control" slot-scope="text, record">
                    <a-tag :color="color" v-if="isHasPermission()('sys.config.update')" @click.stop="update(record)">修改
                    </a-tag>
                </template>
            </a-table>
        </div>
        <a-modal
            :title="form.getFieldValue('id') ? '修改参数' : '添加参数'"
            :width="640"
            :visible="visible"
            :confirmLoading="confirmLoading"
            :maskClosable="false"
            @ok="handleSubmit"
            @cancel="handleCancel"
        >
            <a-spin :spinning="confirmLoading">
                <a-form :form="form" autocomplete="off">
                    <a-form-item label="参数名" :labelCol="labelCol" :wrapperCol="wrapperCol">
                        <a-input
                            placeholder="建议使用英文参数名"
                            v-decorator="['paramKey', { rules: [{ required: true, min: 1, message: '请选择参数名' }] }]"
                        />
                        <a-input style="display: none" type="hidden" v-decorator="['id', {}]"/>
                    </a-form-item>
                    <a-form-item label="参数值" :labelCol="labelCol" :wrapperCol="wrapperCol">
                        <a-input
                            placeholder="参数值"
                            v-decorator="[
                'paramValue',
                {
                  rules: [
                    {
                      required: true,
                      message: '请填充参数值！'
                    }
                  ]
                }
              ]"
                        />
                    </a-form-item>
                    <a-form-item label="备注" :labelCol="labelCol" :wrapperCol="wrapperCol">
                        <a-input placeholder="备注" v-decorator="['remark', {}]"/>
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
        title: "id",
        dataIndex: "id"
    },
        {
            title: "参数名",
            dataIndex: "paramKey"
        },
        {
            title: "参数值",
            dataIndex: "paramValue",
        },
        {
            title: "备注",
            dataIndex: "remark"
        },
        {
            title: '操作',
            dataIndex: 'control',
            scopedSlots: {customRender: 'control'},
        }]
    export default {
        data() {
            return {
                data: [],
                columns,
                selectedRowKeys: [],
                selectedItems: [],
                loading: false,
                queryData: {
                    paramKey: "",
                    page: 1,
                    limit: 10
                },
                pagination: {
                    showSizeChanger: true,
                    total: 0,
                    current: 0,
                    showTotal: total => `共${total}条数据`,
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
                options: [],
            }
        },
        computed: {
            ...mapGetters(['color'])
        },
        mounted() {
            if (!this.isHasPermission()('sys.config.list')) {
                return
            }
            this.loadData();//加载参数列表
        },
        methods: {
            ...mapGetters(['isHasPermission']),
            handleChange(value, info) {
                this.curSelect = info.data.props
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
                this.$http.post(api.config.list, this.queryData).then(res => {
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
                    setFieldsValue(record)
                    for (let i in that.options) {
                        that.options[i].checked = false
                        for (let s in record.configIdList) {
                            if (that.options[i].id == record.configIdList[s]) {
                                that.options[i].checked = true
                            }
                        }
                    }
                }, 0)
            },
            addConfig() {
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
                    if (!errors) {
                        values.configIdList = this.curSelect
                        this.$http({
                            url: api.config.saveOrUpdate,
                            method: 'post',
                            headers: {
                                send: 'json'
                            },
                            data: values,
                        }).then(res => {
                            if(res.code == 0){
                                let targetData = res.result;
                                this.addOrUpdateHtmlData(targetData)
                                this.visible = false
                            }else{
                                this.$message.error(res.msg)
                            }
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
                                url: api.config.deleteBatch,
                                method: 'post',
                                headers: {
                                    send: 'json'
                                },
                                data: arr,
                            }).then(res => {
                                if(res.code == 0){
                                    self.$message.success('删除成功！')
                                    for (let i in self.selectedItems) {
                                        self.deleteHtmlData(self.selectedItems[i], self.data)
                                    }
                                    self.pagination.total = self.pagination.total - self.selectedItems.length
                                    self.selectedRowKeys.length = 0
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
            deleteHtmlData(targetData) {
                let indexOf = this.indexOf(targetData, this.data, "id")
                if (indexOf != -1) {
                    this.data.splice(indexOf, 1)
                }
                if (this.data.length == 0) {
                    this.loadData()
                }
            },
            addOrUpdateHtmlData(targetData) {
                let indexOf = this.indexOf(targetData, this.data, "id")
                if (indexOf != -1) {
                    this.data[indexOf] = targetData
                    this.$message.success("修改成功！")
                    return 0
                } else {
                    this.data = [targetData].concat(this.data)
                    this.$message.success("添加成功！")
                    return 1
                }
            },
            handleCancel() {
                this.visible = false
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
