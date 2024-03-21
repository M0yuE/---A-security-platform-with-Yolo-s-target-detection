<template>
    <a-layout class="main">
        <div class="query">
            <a-input-search
                placeholder="输入数据项名/设备名查询"
                style="width: 200px"
                @search="onSearch"
                enterButton
                v-model="queryData.name"
            />
            <a-button v-show="isHasPermission()('secData.warnMsg.read')" class="btn"
                      type="primary" @click="readData">标记已读
            </a-button>
        </div>
        <div>
            <a-table :locale="{'emptyText':'暂无数据'}" :customRow="customRow" :pagination="pagination" :loading="loading"
                     :rowSelection="{selectedRowKeys: selectedRowKeys, onChange: onSelectChange}" :columns="columns"
                     :dataSource="data">
                <template slot="isRead" slot-scope="text">
                    <a-tag :color="text == 1 ? 'green' : 'red'">{{text == 1 ? '已读' : '未读'}}</a-tag>
                </template>
            </a-table>
        </div>
    </a-layout>
</template>

<script>
    import {mapGetters,mapActions} from 'vuex'
    import api from '@/api'

    const columns = [{
        title: 'id',
        dataIndex: 'id',
    }, {
        title: '警告消息',
        dataIndex: 'msg',
    }, {
        title: '设备名称',
        dataIndex: 'equipmentName',
    }, {
        title: '数据项名',
        dataIndex: 'dataName',
    },{
        title: '创建时间',
        dataIndex: 'createTime',
    },{
        title: '是否已读',
        dataIndex: 'isRead',
        scopedSlots: {customRender: 'isRead'},
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
                    name: "",
                    page: 1,
                    limit: 10,
                },
                pagination: {
                    showSizeChanger: true,
                    total: 0,
                    current: 0,
                    showTotal: total => `共 ${total} 条数据`,
                    onChange: this.pageChange,
                    onShowSizeChange: (current, pageSize) => this.queryData.limit = pageSize
                },
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
            ...mapGetters(['color']),
        },
        mounted() {
            if (!this.isHasPermission()('secData.warnMsg.list')) {
                return
            }
            this.loadData();
        },
        methods: {
            ...mapActions(['SetWarnCount']),
            ...mapGetters(['isHasPermission']),
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
            loadData() {
                this.loading = true
                this.$http.post(api.warnMsg.list, this.queryData).then(res => {
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
            readData() {
                let arr = [];
                this.selectedItems.forEach(item => {
                    arr.push(item.id)
                })
                if(!arr.length){
                    this.$message.warning('请选择要已读的数据！')
                    return
                }
                const self = this
                this.$confirm({
                    title: '已读操作！',
                    content: '您是否要已读选中项？',
                    okText: '确认',
                    okType: 'primary',
                    cancelText: '取消',
                    onOk() {
                        return new Promise((resolve, reject) => {
                            self.$http({
                                url: api.warnMsg.read,
                                method: 'post',
                                headers: {
                                    send: 'json'
                                },
                                data: arr
                            }).then(res => {
                                if (res.code == 0) {
                                    self.$message.success('操作成功！')
                                    self.selectedItems = []
                                    self.selectedRowKeys = []
                                    self.loadData()
                                    self.getWarnCount()
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
            getWarnCount(){
                this.$http.post(api.warnMsg.warnCount).then(res => {
                    if(res.code == 0){
                        this.SetWarnCount(res.count)
                    }else{
                        this.$message.error(res.msg)
                    }
                    this.loading = false
                }).catch(err => {
                    console.log(err)
                })
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
