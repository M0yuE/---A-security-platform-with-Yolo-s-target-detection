<template>
    <a-layout class="main">
        <div class="query">
            <a-input-search
                placeholder="输入用户名查询"
                style="width: 200px"
                @search="onSearch"
                enterButton
                v-model="queryData.username"
            />
            <a-button class="btn" type="primary" v-if="isHasPermission()('sys.user.save')" @click="addUser">新增
            </a-button>
            <a-button v-show="selectedRowKeys.length > 0 && isHasPermission()('sys.user.delete')" class="btn"
                      type="danger" @click="deleteData">删除
            </a-button>
        </div>
        <div>
            <a-table :locale="{'emptyText':'暂无数据'}" :customRow="customRow" :pagination="pagination" :loading="loading"
                     :rowSelection="{selectedRowKeys: selectedRowKeys, onChange: onSelectChange}" :columns="columns"
                     :dataSource="data">
                <template slot="status" slot-scope="text">
                    <a-tag :color="text == 1 ? 'green' : 'cyan'">{{text == 1 ? '启用' : '禁用'}}</a-tag>
                </template>
                <template slot="control" slot-scope="text, record">
                    <a-tag :color="color" v-if="isHasPermission()('sys.user.update')" @click.stop="update(record)">修改</a-tag>
                </template>
            </a-table>
        </div>
        <a-modal
            :title="form.getFieldValue('userId') ? '修改用户' : '添加用户'"
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
                        label="用户名"
                        :labelCol="labelCol"
                        :wrapperCol="wrapperCol"
                        has-feedback
                        :validate-status="usernameStatus"
                        :help="usernameHelp"
                    >
                        <a-input @blur="validateUserName" v-decorator="['username',{}]"/>
                        <a-input style="display: none" type="hidden" v-decorator="['userId',{}]"/>
                    </a-form-item>
                    <a-form-item
                        label="密码"
                        :labelCol="labelCol"
                        :wrapperCol="wrapperCol"
                        v-if="!passwdDisabled"
                    >
                        <a-input
                            v-decorator="['password', {rules: [{required: true, min:5, message: '请输入至少输入五位密码！'}]}]"/>
                    </a-form-item>
                    <a-form-item
                        label="邮箱"
                        :labelCol="labelCol"
                        :wrapperCol="wrapperCol"
                    >
                        <a-input
                            v-decorator="['email', {rules: [{required: true,pattern: /^[a-zA-Z0-9]+([-_.][a-zA-Z0-9]+)*@[a-zA-Z0-9]+([-_.][a-zA-Z0-9]+)*\.[a-z]{2,}$/, message: '请输入正确的邮箱！'}]}]"/>
                    </a-form-item>
                    <a-form-item
                        label="电话"
                        :labelCol="labelCol"
                        :wrapperCol="wrapperCol"
                    >
                        <a-input
                            v-decorator="['mobile', {rules: [{required: true,pattern: /^1[3456789]\d{9}$/, message: '请输入正确的手机号！'}]}]"/>
                    </a-form-item>
                    <a-form-item
                        label="角色"
                        :labelCol="labelCol"
                        :wrapperCol="wrapperCol"
                    >
                        <a-row>
                            <a-col v-bind:key="item.roleId" v-for="item in options">
                                <a-checkbox :checked="item.checked" @change="roleOnChange(item)" :value="item.roleId">
                                    {{item.roleName}}
                                </a-checkbox>
                            </a-col>
                        </a-row>
                    </a-form-item>
                    <a-form-item
                        label="是否启用"
                        :labelCol="labelCol"
                        :wrapperCol="wrapperCol">
                        <a-input style="display: none" type="hidden" v-decorator="['status',{initialValue:1}]"/>
                        <a-radio-group :options="[{label:'启用',value:1},{label:'禁用',value:0}]" @change="changeStatus"
                                       :value="statusVal"/>
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
        dataIndex: 'userId',
    }, {
        title: '用户名',
        dataIndex: 'username',
    }, {
        title: '邮箱',
        dataIndex: 'email',
    }, {
        title: '电话',
        dataIndex: 'mobile',
    }, {
        title: '状态',
        dataIndex: 'status',
        scopedSlots: {customRender: 'status'},
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
                    username: "",
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
                passwdDisabled: false,
                usernameStatus: '',
                usernameHelp: '',
                oldUsername: '',
                statusVal: 1
            }
        },
        computed: {
            ...mapGetters(['color'])
        },
        mounted() {
            if (!this.isHasPermission()('sys.user.list')) {
                return
            }
            this.loadData();//加载用户列表
            this.$http.post(api.role.listRole).then(res => {
                if(res.code == 0){
                    this.options = res.list.map(val => {
                        val.checked = false
                        return val
                    })
                }else{
                    this.$message.error(res.msg)
                }
            }).catch(err => {
                console.log(err)
            })
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
                                if (this.selectedItems[i].userId == record.userId) {
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
            changeStatus(e) {
                let val = e.target.value
                this.form.setFieldsValue({'status': val})
                this.statusVal = val
            },
            async validateUserName() {
                const {form: {getFieldValue}} = this
                const username = getFieldValue('username')
                let helpStr;
                if (!username) {
                    helpStr = '请输入两位用户名！'
                } else if (username.trim() == '') {
                    helpStr = '请不要输入空字符！'
                } else if (username.trim().length < 2) {
                    helpStr = '请不至少输入两位！'
                }
                if (helpStr) {
                    this.usernameHelp = helpStr
                    this.usernameStatus = 'error'
                    return false
                }
                if (username.trim() != this.oldUsername) {
                    this.usernameHelp = ''
                    this.usernameStatus = 'validating'
                    await this.$http.post(api.user.isNotExists, {username: username}).then(res => {
                        if(res.code == 0){
                            if (res.result) {
                                this.usernameHelp = '用户名可用！'
                                this.usernameStatus = 'success'
                            } else {
                                this.usernameHelp = '用户名已被使用！'
                                this.usernameStatus = 'error'
                            }
                        }else{
                            this.$message.error(res.msg)
                        }
                    }).catch(err => {
                        console.log(err)
                    })
                } else {
                    this.usernameHelp = ''
                    this.usernameStatus = ''
                }
                return true
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
                this.$http.post(api.user.list, this.queryData).then(res => {
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
                this.passwdDisabled = true
                this.usernameStatus = ''
                this.usernameHelp = ''
                this.visible = true
                const {form: {setFieldsValue}} = this
                this.oldUsername = record.username
                let that = this
                setTimeout(() => {
                    that.statusVal = record.status
                    that.curSelect = record.roleIdList
                    setFieldsValue(record)
                    for (let i in that.options) {
                        that.options[i].checked = false
                        for (let s in record.roleIdList) {
                            if (that.options[i].roleId == record.roleIdList[s]) {
                                that.options[i].checked = true
                            }
                        }
                    }
                }, 0)
            },
            addUser() {
                this.form.resetFields()
                this.visible = true
                this.usernameStatus = ''
                this.usernameHelp = ''
                this.passwdDisabled = false
                this.oldUsername = ''
                for (let i in this.options) {
                    this.options[i].checked = false
                }
            },
            handleSubmit() {
                const {form: {validateFields}} = this
                if (this.usernameStatus != 'success') {
                    const isValidated = this.validateUserName();
                    if (!isValidated) {
                        return
                    }
                }
                this.confirmLoading = true
                validateFields((errors, values) => {
                    if (!errors && (this.usernameStatus == '' || this.usernameStatus == 'success')) {
                        values.roleIdList = this.curSelect
                        this.$http({
                            url: api.user.saveOrUpdate,
                            method: 'post',
                            headers: {
                                send: 'json'
                            },
                            data: values,
                        }).then(res => {
                            if (res.code == 0) {
                                let targetData = res.result;
                                targetData.roleid = this.curSelect.roleid
                                targetData.rolename = this.curSelect.rolename
                                if (this.addOrUpdateHtmlData(targetData)) {
                                    //改变数据数
                                    this.pagination.total = this.pagination.total + 1
                                }
                                this.visible = false
                            } else {
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
                    arr.push(item.userId)
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
                                url: api.user.deleteBatch,
                                method: 'post',
                                headers: {
                                    send: 'json'
                                },
                                data: arr
                            }).then(res => {
                                if (res.code == 0) {
                                    self.$message.success('删除成功！')
                                    for (let i in self.selectedItems) {
                                        self.deleteHtmlData(self.selectedItems[i], self.data)
                                    }
                                    //改变数据数
                                    self.pagination.total = self.pagination.total - self.selectedItems.length
                                    self.selectedRowKeys.length = 0
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
            deleteHtmlData(targetData) {
                let indexOf = this.indexOf(targetData, this.data, "userId")
                if (indexOf != -1) {
                    this.data.splice(indexOf, 1)
                }
                if (this.data.length == 0) {
                    this.loadData()
                }
            },
            addOrUpdateHtmlData(targetData) {
                let indexOf = this.indexOf(targetData, this.data, "userId")
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
