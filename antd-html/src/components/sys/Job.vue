<template>
    <a-layout class="main">
        <div class="query">
            <a-input-search
                placeholder="输入类名称"
                style="width: 200px"
                @search="onSearch"
                enterButton
                v-model="queryData.beanName"
            />
            <a-button class="btn" type="primary" v-if="isHasPermission()('sys.schedule.save')" @click="addJob">新增
            </a-button>
            <a-button v-show="selectedRowKeys.length > 0 && isHasPermission()('sys.schedule.delete')" class="btn"
                      type="danger" @click="deleteData">删除
            </a-button>
            <a-button v-if="isHasPermission()('sys.schedule.pause')" class="btn" type="primary" @click="pause">暂停
            </a-button>
            <a-button v-if="isHasPermission()('sys.schedule.resume')" class="btn" type="primary" @click="resume">恢复
            </a-button>
            <a-button v-if="isHasPermission()('sys.schedule.run')" class="btn" type="primary" @click="runOnce">立即执行
            </a-button>
            <a-button v-if="isHasPermission()('sys.schedule.run')" class="btn" type="primary" @click="goLog">日志列表
            </a-button>
        </div>
        <div>
            <a-table :locale="{'emptyText':'暂无数据'}" :customRow="customRow" :pagination="pagination" :loading="loading"
                     :rowSelection="{selectedRowKeys: selectedRowKeys, onChange: onSelectChange}" :columns="columns"
                     :dataSource="data">
                <template slot="jobStatus" slot-scope="text, record">
                    <a-tag :color="record.status == 1 ? 'blue' : 'green'">{{record.status == 1 ? '暂停' : '正常'}}</a-tag>
                </template>
                <template slot="control" slot-scope="text, record">
                    <a-tag :color="color" v-if="isHasPermission()('sys.schedule.update')" @click.stop="update(record)">修改
                    </a-tag>
                </template>
            </a-table>
        </div>
        <a-modal
            :title="form.getFieldValue('jobId') ? '修改定时任务' : '添加定时任务'"
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
                        label="类名称"
                        :labelCol="labelCol"
                        :wrapperCol="wrapperCol">
                        <a-input
                            v-decorator="['beanName',  {rules: [{ required: true, message: '请输入类名称' }], validateTrigger: 'blur'}]"/>
                        <a-input style="display: none" type="hidden" v-decorator="['jobId']"/>
                    </a-form-item>
                    <a-form-item
                        label="参数"
                        :labelCol="labelCol"
                        :wrapperCol="wrapperCol">
                        <a-input v-decorator="['params']"
                        />
                    </a-form-item>
                    <a-form-item
                        label="cron表达式"
                        :labelCol="labelCol"
                        :wrapperCol="wrapperCol">
                        <a-input
                            v-decorator="['cronExpression',  {rules: [{ required: true, message: '请输入cron表达式' }], validateTrigger: 'blur'}]"
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
        dataIndex: 'jobId',
    }, {
        title: '类名称',
        dataIndex: 'beanName',
    }, {
        title: '参数',
        dataIndex: 'params',
    }, {
        title: 'cron表达式',
        dataIndex: 'cronExpression',
    }, {
        title: '状态',
        dataIndex: 'status',
        scopedSlots: {customRender: 'jobStatus'},
    }, {
        title: '创建时间',
        dataIndex: 'createTime',
    }, {
        title: '操作',
        dataIndex: 'control',
        scopedSlots: {customRender: 'control'},
    }];
    export default {
        data() {
            return {
                data: [],
                columns,
                selectedRowKeys: [],
                selectedItems: [],
                loading: false,
                queryData: {
                    beanName: "",
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
                options: [],
            }
        },
        computed: {
            ...mapGetters(['color'])
        },
        mounted() {
            if (!this.isHasPermission()('sys.schedule.list')) {
                return
            }
            this.loadData();//加载数据
        },
        methods: {
            ...mapGetters(['isHasPermission']),
            onSelectChange(selectedRowKeys, selectedItems) {
                this.selectedRowKeys = selectedRowKeys
                this.selectedItems = selectedItems
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
                                if (this.selectedItems[i].jobId == record.jobId) {
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
            goLog() {
                this.$router.push({path: '/schedule/log'})
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
                this.$http.post(api.schedule.list, this.queryData).then(res => {
                    if(res.code == 0){
                        this.loading = false;
                        /*获取页面返回的数据*/
                        this.data = res.page.list
                        this.pagination.total = res.page.totalCount
                        this.pagination.current = res.page.currPage
                    }else{
                        this.$message.error(res.msg)
                    }
                }).catch(err => {
                    console.log(err)
                })
            },
            addJob() {
                this.form.resetFields()
                this.visible = true
            },
            update(record) {
                console.log(JSON.stringify(record))
                this.visible = true;
                const {form: {setFieldsValue}} = this
                let that = this
                setTimeout(() => {
                    setFieldsValue(record)
                }, 0)
            },
            handleSubmit() {
                /*表单验证*/
                const {form: {validateFields}} = this
                this.confirmLoading = true
                validateFields((errors, values) => {
                    console.log(values)
                    let url = values.jobId == null ? api.schedule.saveSchedule : api.schedule.updateSchedule;
                    if (!errors) {
                        this.$http({
                            url: url,
                            method: 'post',
                            headers: {
                                send: 'json'
                            },
                            data: values,
                        }).then(res => {
                            if (res.code == 0) {
                                /*新增 修改的model*/
                                this.visible = false;
                                this.addOrUpdateHtmlData(res.result);
                            } else {
                                this.$message.error(res.msg);
                            }
                            /*加载动画*/
                            this.confirmLoading = false;
                        }).catch(err => {
                            console.log(err)
                        })
                    } else {
                        this.confirmLoading = false
                    }
                })
            },
            pause() {
                let arr = [];
                this.selectedItems.forEach(item => {
                    arr.push(item.jobId)
                });
                if (arr.length < 1) {
                    this.$message.error('请最少选则一条数据操作');
                    return;
                }
                const self = this
                this.$confirm({
                    title: '暂停操作！',
                    content: '您是否要暂停选中项？',
                    okText: '确认',
                    okType: 'danger',
                    cancelText: '取消',
                    onOk() {
                        return new Promise((resolve, reject) => {
                            self.$http({
                                url: api.schedule.pause,
                                method: 'post',
                                headers: {
                                    send: 'json'
                                },
                                data: arr,
                            }).then(res => {
                                if(res.code == 0){
                                    self.$message.success('暂停成功！')
                                    self.loadData();
                                    resolve()
                                }else{
                                    self.$message.success(res.msg)
                                    reject()
                                }
                            })
                        }).catch((e) => console.log(e));
                    },
                    onCancel() {
                    },
                });
            },
            resume() {
                let arr = [];
                this.selectedItems.forEach(item => {
                    arr.push(item.jobId)
                });
                if (arr.length < 1) {
                    this.$message.error('请最少选则一条数据操作');
                    return;
                }
                const self = this
                this.$confirm({
                    title: '恢复操作！',
                    content: '您是否要恢复选中项？',
                    okText: '确认',
                    okType: 'danger',
                    cancelText: '取消',
                    onOk() {
                        return new Promise((resolve, reject) => {
                            self.$http({
                                url: api.schedule.resume,
                                method: 'post',
                                headers: {
                                    send: 'json'
                                },
                                data: arr,
                            }).then(res => {
                                if(res.code == 0){
                                    self.$message.success('恢复成功！')
                                    self.loadData();
                                    resolve();
                                }else{
                                    self.$message.error(res.msg)
                                    reject()
                                }
                            })
                        }).catch((e) => console.log(e));
                    },
                    onCancel() {
                    },
                });
            },
            runOnce() {
                let arr = [];
                this.selectedItems.forEach(item => {
                    arr.push(item.jobId)
                });
                if (arr.length < 1) {
                    this.$message.error('请最少选则一条数据操作');
                    return;
                }
                const self = this
                this.$confirm({
                    title: '立即执行操作！',
                    content: '您是否要立即执行选中项？',
                    okText: '确认',
                    okType: 'danger',
                    cancelText: '取消',
                    onOk() {
                        return new Promise((resolve, reject) => {
                            self.$http({
                                url: api.schedule.runOnce,
                                method: 'post',
                                headers: {
                                    send: 'json'
                                },
                                data: arr,
                            }).then(res => {
                                if(res.code == 0){
                                    self.$message.success('立即执行成功！')
                                    resolve()
                                }else{
                                    self.$message.error(res.msg)
                                    reject()
                                }
                            })
                        }).catch((e) => console.log(e));
                    },
                    onCancel() {
                    },
                });
            },
            deleteData() {
                let arr = [];
                this.selectedItems.forEach(item => {
                    arr.push(item.jobId)
                })
                if (arr.length < 1) {
                    this.$message.error('请最少选则一条数据操作');
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
                                url: api.schedule.deleteBatch,
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
                                    self.selectedRowKeys.length = 0
                                    resolve()
                                }else{
                                    reject()
                                }
                            })
                        }).catch((e) => console.log(e));
                    },
                    onCancel() {
                    },
                });
            },
            deleteHtmlData(targetData) {
                let indexOf = this.indexOf(targetData, this.data, "jobId")
                if (indexOf != -1) {
                    this.data.splice(indexOf, 1);
                    this.pagination.total = this.pagination.total - this.selectedItems.length;
                }
                if (this.data.length == 0) {
                    this.loadData()
                }
            },
            formatDate(now) {

                let year = now.getFullYear();
                let month = now.getMonth() + 1 < 10 ? '0' + now.getMonth() : now.getMonth();
                let date = now.getDate() < 10 ? '0' + now.getDate() : now.getDate();
                let hour = now.getHours() < 10 ? '0' + now.getHours() : now.getHours();
                let minute = now.getMinutes() < 10 ? '0' + now.getMinutes() : now.getMinutes();
                let second = now.getSeconds() < 10 ? '0' + now.getSeconds() : now.getSeconds();
                return year + "-" + month + "-" + date + " " + hour + ":" + minute + ":" + second;
            },
            addOrUpdateHtmlData(targetData) {
                let indexOf = this.indexOf(targetData, this.data, "jobId")
                targetData.createTime = this.formatDate(new Date());
                if (indexOf != -1) {
                    this.data[indexOf] = targetData
                    this.$message.success("修改成功！")
                } else {
                    this.data = [targetData].concat(this.data)
                    this.$message.success("添加成功！")
                    this.pagination.total = this.pagination.total + 1;
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
