<template>
    <a-layout class="main">
        <div class="query">
            <a-input-search
                placeholder="输入名称查询"
                style="width: 200px"
                @search="onSearch"
                enterButton
                v-model="queryData.name"
            />
            <a-button class="btn" type="primary" @click="addUser">新增
            </a-button>
            <a-button v-show="selectedRowKeys.length > 0" class="btn"
                      type="danger" @click="deleteData">删除
            </a-button>
        </div>
        <div>
            <a-table :locale="{'emptyText':'暂无数据'}" :customRow="customRow" :pagination="pagination" :loading="loading"
                     :rowSelection="{selectedRowKeys: selectedRowKeys, onChange: onSelectChange}" :columns="columns"
                     :dataSource="data">
                <template slot="control" slot-scope="text, record">
                    <a-tag :color="color" @click.stop="update(record)">修改</a-tag>
                    <a-tag :color="color" @click.stop="preview(record)">预览</a-tag>
                </template>
            </a-table>
        </div>
        <a-modal
            :title="form.getFieldValue('id') ? '修改视频' : '添加视频'"
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
                        label="名称"
                        :labelCol="labelCol"
                        :wrapperCol="wrapperCol"
                    >
                        <a-input
                            v-decorator="['name', {rules: [{required: true, message: '请输入名称！'}]}]"/>
                        <a-input style="display: none" v-decorator="['id', {}]"/>
                    </a-form-item>
                    <a-form-item
                        label="播放源"
                        :labelCol="labelCol"
                        :wrapperCol="wrapperCol"
                    >
                        <a-input
                            v-decorator="['src', {rules: [{required: true, message: '请输入播放源！'}]}]"/>
                    </a-form-item>
                </a-form>
            </a-spin>
        </a-modal>
        <a-modal
            :title="'视频预览'"
            :width="1500"
            :visible="streamShow"
            :maskClosable="false"
            @ok="closeStream"
            @cancel="closeStream"
        >
            <img :src="curStream" alt="" style="height: 800px" crossorigin>
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
        title: '名称',
        dataIndex: 'name',
    }, {
        title: '播放源',
        dataIndex: 'src',
    },{
        title: '操作',
        dataIndex: 'control',
        scopedSlots: {customRender: 'control'},
    }];

    export default {
        data() {
            return {
                streamShow:false,
                curStream:undefined,
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
            }
        },
        computed: {
            ...mapGetters(['color'])
        },
        mounted() {
            this.loadData()
        },
        methods: {
            ...mapGetters(['isHasPermission']),
            closeStream(){
                this.streamShow = false
                this.curStream = undefined
            },
            preview(record){
                this.curStream = record.src
                this.streamShow = true
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
                this.$http.post(api.video.list, this.queryData).then(res => {
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
                }, 0)
            },
            addUser() {
                this.form.resetFields()
                this.visible = true
            },
            handleSubmit() {
                const {form: {validateFields}} = this
                this.confirmLoading = true
                validateFields((errors, values) => {
                    this.$http({
                        url: api.video.saveOrUpdate,
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
                                url: api.video.deleteBatch,
                                method: 'post',
                                headers: {
                                    send: 'json'
                                },
                                data: arr
                            }).then(res => {
                                if (res.code == 0) {
                                    self.$message.success('删除成功！')
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
