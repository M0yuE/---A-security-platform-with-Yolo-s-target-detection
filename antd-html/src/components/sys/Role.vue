<template>
    <a-layout class="main">
        <div class="query">
            <a-button class="btn" v-if="isHasPermission()('sys.role.save')" type="primary"
                      @click="() => {addModalVisible = true;selectedKeys.length = 0}">新增
            </a-button>
            <a-button v-show="selectedRowKeys.length > 0 && isHasPermission()('sys.role.delete')" class="btn"
                      type="danger" @click="deleteData">删除
            </a-button>
        </div>
        <a-table :locale="{'emptyText':'暂无数据'}" :loading="loading" rowKey="id" :defaultExpandAllRows="true"
                 :pagination="false" :columns="columns" :dataSource="data" :customRow="customRow"
                 :rowSelection="{selectedRowKeys: selectedRowKeys, onChange: onSelectChange}">
            <template slot="control" slot-scope="text, record">
                <a-tag :color="color" v-if="isHasPermission()('sys.role.update')" @click.stop="update(record)">修改</a-tag>
            </template>
        </a-table>
        <a-modal
            :title="form.getFieldValue('roleId') ? '修改角色' : '添加角色'"
            :visible="addModalVisible"
            :confirmLoading="addModalLoading"
            :destroyOnClose="true"
            @ok="addMenu"
            :maskClosable="false"
            @cancel="addModalVisible = false"
        >
            <a-spin :spinning="addModalLoading">
                <a-form :form="form" autocomplete="off">

                    <a-form-item
                        label="角色名称"
                        :labelCol="labelCol"
                        :wrapperCol="wrapperCol"
                    >
                        <a-input v-decorator="['roleName', {rules: [{required: true, message: '请输入角色名称！'}]}]"/>
                        <a-input style="display: none" type="hidden" v-decorator="['roleId',{}]"/>
                        <a-input style="display: none" type="hidden" v-decorator="['menuIdList',{}]"/>
                    </a-form-item>
                    <a-form-item
                        label="备注"
                        :labelCol="labelCol"
                        :wrapperCol="wrapperCol"
                    >
                        <a-input v-decorator="['remark']"/>
                    </a-form-item>
                    <a-form-item
                            label="是否启用"
                            :labelCol="labelCol"
                            :wrapperCol="wrapperCol">
                        <a-input style="display: none" type="hidden" v-decorator="['shopRole',{initialValue:1}]"/>
                        <a-radio-group :options="[{label:'是',value:1},{label:'否',value:0}]" @change="changeStatus"
                                       :value="statusVal"/>
                    </a-form-item>
                    <a-form-item
                        label="角色权限"
                        :labelCol="labelCol"
                        :wrapperCol="wrapperCol"
                    >
                        <a-tree
                            checkable
                            :defaultExpandAll="true"
                            @check="onCheck"
                            :checkedKeys="selectedKeys"
                            :treeData="treeData"
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
        dataIndex: 'roleId',
    }, {
        title: '角色名称',
        dataIndex: 'roleName',
    }, {
        title: '备注',
        dataIndex: 'remark',
    }, {
        title: '操作',
        dataIndex: 'control',
        scopedSlots: {customRender: 'control'},
    }];
    export default {
        name: "Role",
        data() {
            return {
                labelCol: {
                    xs: {span: 24},
                    sm: {span: 5}
                },
                wrapperCol: {
                    xs: {span: 24},
                    sm: {span: 16}
                },
                selectedRowKeys: [],
                selectedItems: [],
                addModalVisible: false,
                addModalLoading: false,
                loading: false,
                form: this.$form.createForm(this),
                autoExpandParent: true,
                checkedKeys: [47],
                selectedKeys: [],
                treeData: [],
                columns,
                data: [],
                statusVal: 0
            }
        },
        watch: {
            checkedKeys(val) {
                console.log('onCheck', val)
            }
        },
        computed: {
            ...mapGetters(['color'])
        },
        mounted() {
            if (!this.isHasPermission()('sys.role.list')) {
                return
            }
            this.getDataList()
            this.$http.post(api.menu.list).then(res => {
                let data = this.getTreeData(res)
                this.treeData = data
            }).catch(err => {
                console.log(err)
            })
        },
        methods: {
            ...mapGetters(['isHasPermission']),
            getDataList(){
                this.loading = true;
                this.$http.post(api.role.list).then(res => {
                    if(res.code == 0){
                        this.data = res.page.list
                    }else{
                        this.$message.error(res.msg)
                    }
                    this.loading = false
                }).catch(err => {
                    console.log(err)
                })
            },
            changeStatus(e) {
                let val = e.target.value
                this.form.setFieldsValue({'shopRole': val})
                this.statusVal = val
            },
            getTreeData(originData) {
                originData.forEach(item => {
                    item.key = item.menuId
                    item.value = item.menuId + ''
                    item.title = item.name
                    if (item.children && item.children.length > 0) {
                        this.getTreeData(item.children)
                    }
                })
                return originData
            },
            onSelectChange(selectedRowKeys, selectedItems) {
                this.selectedRowKeys = selectedRowKeys
                this.selectedItems = selectedItems
            },
            onCheck(selectedKeys) {
                const {form: {getFieldsValue, setFieldsValue}} = this
                setFieldsValue({menuIdList: selectedKeys.join(',')})
                this.selectedKeys = selectedKeys
            },
            addMenu() {
                this.addModalLoading = true;
                const {form: {validateFields}} = this
                validateFields((errors, values) => {
                    if (!errors) {
                        if(values.menuIdList && values.menuIdList.length){
                            values.menuIdList = values.menuIdList.split(',')
                        }
                        this.$http({
                            url: api.role.saveOrUpdate,
                            method: 'post',
                            headers: {
                                send: 'json'
                            },
                            data: values,
                        }).then(res => {
                            if(res.code == 0){
                                this.getDataList()
                                this.addModalVisible = false;
                            }else{
                                this.$message.error(res.msg)
                            }
                            this.addModalLoading = false;
                        }).catch(err => {
                            console.log(err)
                        })
                    } else {
                        this.addModalLoading = false
                    }
                })
            },
            update(record) {
                this.addModalVisible = true
                const {form: {setFieldsValue}} = this
                if (record.menuIdList) {
                    this.selectedKeys = record.menuIdList
                } else {
                    this.selectedKeys.length = 0
                }
                setTimeout(() => {
                    this.statusVal = record.shopRole
                    let fieldObj = {}
                    for (let i in record) {
                        let type = typeof record[i]
                        if (type == 'number' || type == 'string') {
                            fieldObj[i] = record[i]
                        }
                    }
                    fieldObj.menuIdList = record.menuIdList.join(',')
                    setFieldsValue(fieldObj)
                }, 0)
            },
            deleteData() {
                let arr = [];
                this.selectedItems.forEach(item => {
                    arr.push(item.roleId)
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
                                url: api.role.deleteBatch,
                                method: 'post',
                                headers: {
                                    send: 'json'
                                },
                                data: arr,
                            }).then(res => {
                                if(res.code == 0){
                                    self.$message.success('删除成功！')
                                    this.getDataList()
                                    self.selectedRowKeys.length = 0
                                    resolve()
                                }else{
                                    self.$message.error(res.msg)
                                    reject()
                                }
                            })
                        }).catch((e) => console.log('Oops errors!',e));
                    },
                    onCancel() {
                    },
                });
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
                                if (this.selectedItems[i].roleId == record.roleId) {
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
