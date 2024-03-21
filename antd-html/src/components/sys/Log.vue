<template>
    <a-layout class="main">
        <div class="query">
            <a-input-search
                placeholder="用户名、操作名称"
                style="width: 200px"
                @search="onSearch"
                enterButton
                v-model="queryData.key"
            />
        </div>
        <div>
            <a-table :locale="{'emptyText':'暂无数据'}" :customRow="customRow" :pagination="pagination" :loading="loading"
                     :rowSelection="{selectedRowKeys: selectedRowKeys, onChange: onSelectChange}" :columns="columns"
                     :dataSource="data">
                <span style="display: inline-block;min-width: 120px" slot="operation" slot-scope="text">{{ text }}</span>
                <span style="display: inline-block;min-width: 120px;cursor: pointer" slot="method" slot-scope="text" :title="text">{{ computeMethodStr(text) }}</span>
                <span style="display: inline-block;min-width: 120px;cursor: pointer" slot="params" slot-scope="text" :title="text">{{ computeParamsStr(text) }}</span>
            </a-table>
        </div>
    </a-layout>
</template>

<script>
    import {mapGetters} from 'vuex'
    import api from '@/api'

    const columns = [{
        title: 'id',
        dataIndex: 'id',
    }, {
        title: '用户',
        dataIndex: 'username',
    }, {
        title: '操作',
        dataIndex: 'operation',
        scopedSlots: { customRender: 'operation' },
    }, {
        title: '方法',
        dataIndex: 'method',
        scopedSlots: { customRender: 'method' },
    }, {
        title: '参数',
        dataIndex: 'params',
        scopedSlots: { customRender: 'params' },
    },{
        title: 'IP',
        dataIndex: 'ip',
    }, {
        title: '调用时长(ms)',
        dataIndex: 'time',
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
                    key: '',
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
            if (!this.isHasPermission()('sys.log.list')) {
                return
            }
            this.loadData()//加载数据
        },
        methods: {
            ...mapGetters(['isHasPermission']),
            computeMethodStr(str){
                let index = str.indexOf('controller')
                if(index != -1){
                    str = str.substring(index + 11)
                }else if(str.length > 25){
                    str = str.substring(20)
                }
                return str
            },
            computeParamsStr(str){
                if(str.length > 40){
                    str = str.substring(0,40) + '...'
                }
                return str
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
                this.$http.post(api.log.list, this.queryData).then(res => {
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
        }
    }
</script>
<style lang="less" scoped>
    .ant-table td { white-space: nowrap; }
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
