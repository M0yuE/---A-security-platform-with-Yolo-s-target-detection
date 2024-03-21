<template>
    <a-layout class="main">
        <div class="query">
            <a-input-search
                placeholder="输入任务Id"
                style="width: 200px"
                @search="onSearch"
                enterButton
                v-model="queryData.jobId"
            />
            <a-button class="btn" type="primary" @click="back">返回</a-button>
        </div>
        <div>
            <a-table :locale="{'emptyText':'暂无数据'}" :pagination="pagination" :loading="loading" :columns="columns"
                     :dataSource="data">
                <template slot="jobStatus" slot-scope="text, record">
                    <a-tag :color="record.status == 1 ? 'red' : 'green'">{{record.status == 1 ? '成功' : '失败'}}</a-tag>
                </template>
            </a-table>
        </div>
    </a-layout>
</template>

<script>
    import {mapGetters} from 'vuex'
    import api from '@/api'

    const columns = [{
        title: '任务Id',
        dataIndex: 'jobId',
    }, {
        title: '类名称',
        dataIndex: 'beanName',
    }, {
        title: '参数',
        dataIndex: 'params',
    }, {
        title: '状态',
        dataIndex: 'status',
        scopedSlots: {customRender: 'jobStatus'},
    }, {
        title: '耗时(单位:毫秒)',
        dataIndex: 'times',
    }, {
        title: '创建时间',
        dataIndex: 'createTime'
    }
    ];

    export default {
        data() {
            return {
                data: [],
                columns,
                selectedRowKeys: [],
                selectedItems: [],
                loading: false,
                queryData: {
                    jobId: "",
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
        mounted() {
            if (!this.isHasPermission()('sys.schedule.list')) {
                return
            }
            this.loadData();//加载数据
        },
        methods: {
            ...mapGetters(['isHasPermission']),
            onSearch() {
                this.queryData.page = 1
                this.loadData()
            },
            back() {
                history.go(-1);
            },
            pageChange(page) {
                this.queryData.page = page
                this.loadData()
            },
            loadData() {
                this.loading = true
                this.$http.post(api.scheduleLog.list, this.queryData).then(res => {
                    this.loading = false;
                    /*获取页面返回的数据*/
                    this.data = res.page.list
                    this.pagination.total = res.page.totalCount
                    this.pagination.current = res.page.currPage
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
