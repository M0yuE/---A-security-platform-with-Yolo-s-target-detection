<template>
    <a-layout class="main">
        <div class="query">
            <a-button class="btn" type="primary" v-if="isHasPermission()('sys.menu.save')"
                      @click="addModalVisible = true">新增
            </a-button>
            <a-button v-show="selectedRowKeys.length > 0 && isHasPermission()('sys.menu.delete')" class="btn"
                      type="danger" @click="deleteData">删除
            </a-button>
        </div>
        <a-table :locale="{'emptyText':'暂无数据'}" :customRow="customRow" :expandedRowKeys="expandedRowKeys" size="small"
                 @expand="onExpand" :loading="loading" rowKey="menuId" :pagination="false" :columns="columns"
                 :dataSource="data" :rowSelection="{selectedRowKeys: selectedRowKeys, onChange: onSelectChange}">
            <template slot="typeInfo" slot-scope="text, record">
                <a-tag :color="record.type == 1 ? 'blue' : record.type == 2 ? 'cyan' : 'green'">{{record.type == 1 ?
                    '目录' : record.type == 2 ? '菜单' : '按钮'}}
                </a-tag>
            </template>
            <template slot="control" slot-scope="text, record">
                <a-tag :color="color" @click.stop="update(record)" v-if="isHasPermission()('sys.menu.update')">修改</a-tag>
            </template>
        </a-table>
        <a-modal
            :title="form.getFieldValue('menuId') ? '修改菜单' : '添加菜单'"
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
                        label="父级菜单"
                        :labelCol="labelCol"
                        :wrapperCol="wrapperCol"
                    >
                        <a-tree-select
                            showSearch
                            style="width: 300px"
                            :dropdownStyle="{ maxHeight: '400px', overflow: 'auto' }"
                            placeholder='请选择父级菜单'
                            allowClear
                            :treeData="treeData"
                            treeDefaultExpandAll
                            treeNodeFilterProp="title"
                            @change="val => form.setFieldsValue({'parentId':val})"
                            v-decorator="['parentId', {rules: [{required: true, message: '请选择父级菜单！'}]}]"
                        >
                        </a-tree-select>
                    </a-form-item>
                    <a-form-item
                        label="菜单名称"
                        :labelCol="labelCol"
                        :wrapperCol="wrapperCol"
                    >
                        <a-input v-decorator="['name', {rules: [{required: true, message: '请输入菜单名称！'}]}]"/>
                        <a-input style="display:none" type="hidden" v-decorator="['menuId',{}]"/>
                    </a-form-item>
                    <a-form-item
                        label="菜单类型"
                        :labelCol="labelCol"
                        :wrapperCol="wrapperCol"
                    >
                        <a-radio-group buttonStyle="solid" v-decorator="['type',{initialValue: '1'}]">
                            <a-radio-button value="1">目录</a-radio-button>
                            <a-radio-button value="2">菜单</a-radio-button>
                            <a-radio-button value="3">按钮</a-radio-button>
                        </a-radio-group>
                        <!--<a-input v-decorator="['type', {rules: [{required: true, message: '请输菜单类型！'}]}]" />-->
                    </a-form-item>
                    <a-form-item
                        label="菜单权限"
                        :labelCol="labelCol"
                        :wrapperCol="wrapperCol"
                    >
                        <a-input placeholder="目录.菜单.按钮" v-decorator="['perms',{}]"/>
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
        dataIndex: 'menuId',
    }, {
        title: '菜单名称',
        dataIndex: 'name',
    }, {
        title: '菜单类型',
        dataIndex: 'typeInfo',
        scopedSlots: {customRender: 'typeInfo'},
    }, {
        title: '菜单权限',
        dataIndex: 'perms',
    }, {
        title: '操作',
        dataIndex: 'control',
        scopedSlots: {customRender: 'control'},
    }];
    export default {
        data() {
            return {
                treeData: [],
                labelCol: {
                    xs: {span: 24},
                    sm: {span: 5}
                },
                wrapperCol: {
                    xs: {span: 24},
                    sm: {span: 16}
                },
                data: [],
                columns,
                selectedRowKeys: [],
                selectedItems: [],
                addModalVisible: false,
                addModalLoading: false,
                loading: false,
                expandedRowKeys: [],
                form: this.$form.createForm(this)
            }
        },
        watch: {
            'data': {
                immediate: true,
                handler(value) {
                    this.updateTreeData()
                },
                deep: true
            }
        },
        computed: {
            ...mapGetters(['color'])
        },
        mounted() {
            if (!this.isHasPermission()('sys.menu.list')) {
                return
            }
            this.$http.post(api.menu.list).then(res => {
                this.data = res
                this.getAllKeys(res, this.expandedRowKeys)
                this.updateTreeData()
                this.loading = false
            }).catch(err => {
                console.log(err)
            })
        },
        methods: {
            ...mapGetters(['isHasPermission']),
            getAllKeys(originData, keys) {
                originData.forEach(item => {
                    keys.push(item.menuId)
                    if (item.children && item.children.length > 0) {
                        this.getAllKeys(item.children, keys)
                    }
                })
            },
            update(record) {
                this.addModalVisible = true
                const {form: {setFieldsValue}} = this
                setTimeout(() => {
                    let fieldObj = {}
                    for (let i in record) {
                        let type = typeof record[i]
                        if (type == 'number') {
                            fieldObj[i] = record[i] + ''
                        } else if (type == 'string') {
                            fieldObj[i] = record[i]
                        }
                    }
                    setFieldsValue(fieldObj)
                }, 0)
            },
            customRow(record) {
                return {
                    on: {
                        click: () => {
                            let flag = false
                            let index
                            for (let i = 0; i < this.selectedRowKeys.length; i++) {
                                if (this.selectedRowKeys[i] == record.menuId) {
                                    flag = true
                                    index = i
                                    break
                                }
                            }
                            if (flag) {
                                this.selectedRowKeys.splice(index, 1)
                            } else {
                                this.selectedRowKeys.push(record.menuId)
                            }
                            for (let i = 0; i < this.selectedItems.length; i++) {
                                if (this.selectedItems[i].menuId == record.menuId) {
                                    flag = true
                                    index = i
                                    break
                                }
                            }
                            if (flag) {
                                this.selectedItems.splice(index, 1)
                            } else {
                                this.selectedItems.push(record)
                            }
                        }
                    }
                }
            },
            onExpand(open, record) {
                let index = this.expandedRowKeys.indexOf(record.key)
                if (open) {
                    if (index == -1) {
                        this.expandedRowKeys.push(record.key)
                    }
                } else {
                    if (index != -1) {
                        this.expandedRowKeys.splice(index, 1)
                    }
                }
            },
            updateTreeData() {
                this.treeData = [{
                    id: 0,
                    key: 0,
                    title: '一级菜单',
                    value: "0",
                    children: this.getTreeData(this.data)
                }];
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
            clearSelectedData(){
                this.selectedRowKeys = []
                this.selectedItems = []
            },
            deleteData() {
                let arr = [];
                this.selectedItems.forEach(item => {
                    arr.push(item.menuId)
                })
                if (arr.length > 1) {
                    this.$message.warn("请选择一条记录")
                    return
                }
                let str = arr.join(',')
                const self = this
                this.$confirm({
                    title: '你确定要删除选中项吗？',
                    content: '点击确认将会删除选中项及子菜单项！',
                    okText: '确认',
                    okType: 'danger',
                    cancelText: '取消',
                    onOk() {
                        return new Promise((resolve, reject) => {
                            self.$http.post(api.menu.deleteBatch, {menuId: str}).then(res => {
                                if(res.code == 0){
                                    self.$message.success('删除成功！')
                                    for (let i in self.selectedItems) {
                                        self.deleteHtmlData(self.selectedItems[i], self.data)
                                    }
                                    self.clearSelectedData()
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
            deleteHtmlData(targetData, originArr) {//服务器返回删除成功后直接删除dom元素
                let indexOf = this.indexOf(targetData, originArr, "menuId")
                if (indexOf != -1) {
                    originArr.splice(indexOf, 1)
                } else {
                    for (let s in originArr) {
                        if (originArr[s].children && originArr[s].children.length > 0) {
                            this.deleteHtmlData(targetData, originArr[s].children)
                        }
                    }
                }
            },
            addHtmlData(targetData, originArr) {//将此元素插入table中
                if (targetData.parentId == 0) {//如果是顶级目录直接push
                    originArr.push(targetData)
                    return;
                }
                let indexOf = this.indexOfParent(targetData, originArr)
                if (indexOf != -1) {
                    if (!originArr[indexOf].children) {
                        originArr[indexOf].children = []
                    }
                    originArr[indexOf].children.push(targetData)
                    this.updateTreeData()
                } else {
                    for (let s in originArr) {
                        if (originArr[s].children && originArr[s].children.length > 0) {
                            this.addHtmlData(targetData, originArr[s].children)
                        }
                    }
                }
            },
            updateHtmlData(targetData, originArr) {//更新dom元素dom元素
                let indexOf = this.indexOf(targetData, originArr, "menuId")
                if (indexOf != -1) {
                    if (originArr[indexOf].children) {
                        targetData.children = originArr[indexOf].children
                    }
                    originArr[indexOf] = targetData;
                    this.updateTreeData()
                } else {
                    for (let s in originArr) {
                        if (originArr[s].children && originArr[s].children.length > 0) {
                            this.updateHtmlData(targetData, originArr[s].children)
                        }
                    }
                }
            },
            addMenu() {
                this.addModalLoading = true;
                const {form: {validateFields}} = this
                validateFields((errors, values) => {
                    if (!errors) {
                        this.$http({
                            url: api.menu.saveOrUpdate,
                            method: 'post',
                            headers: {
                                send: 'json'
                            },
                            data: values,
                        }).then(res => {
                            if (res.code == 0) {
                                if (res.isUpdate) {
                                    this.updateHtmlData(res.result, this.data)
                                    this.$message.success('修改成功！')
                                } else {
                                    this.addHtmlData(res.result, this.data)
                                    this.$message.success('添加成功！')
                                }
                                this.addModalVisible = false;
                            } else {
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
            indexOfParent(targetData, originArr) {
                for (let i in originArr) {
                    if (originArr[i].menuId && targetData.parentId && originArr[i].menuId == targetData.parentId) {
                        return i
                    }
                }
                return -1
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
