<template>
    <div>
        <div class="query">
            <a-input-search
                placeholder="输入数据项名查询"
                style="width: 200px;margin-right: 10px;margin-bottom: 20px"
                @search="onSearch"
                enterButton
                v-model="queryData.name"
            />
            <a-button style="margin-right: 10px" class="btn" type="primary" v-if="isHasPermission()('connectEquipment.equipment.dataWrite')" @click="addRecord">新增
            </a-button>
            <a-button v-show="selectedRowKeys.length > 0 && isHasPermission()('connectEquipment.equipment.dataDelete')" class="btn"
                      type="danger" @click="deleteData">删除
            </a-button>
        </div>
        <div>
            <a-table :locale="{'emptyText':'暂无数据'}" :customRow="customRow" :pagination="pagination" :loading="loading"
                     :rowSelection="{selectedRowKeys: selectedRowKeys, onChange: onSelectChange}" :columns="columns"
                     :dataSource="data">
                <template slot="type" slot-scope="text">
                    <a-tag :color="text == 0 ? 'green' : 'red'">{{text == 0 ? '状态指令' : '控制指令'}}</a-tag>
                </template>
                <template slot="control" slot-scope="text, record">
                    <a-tag :color="color" v-if="isHasPermission()('connectEquipment.equipment.dataWrite')" @click.stop="update(record)">修改</a-tag>
                </template>
            </a-table>
        </div>
        <a-modal
            :title="form.getFieldValue('id') ? '修改设备' : '修改设备'"
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
                        label="数据项名称"
                        :labelCol="labelCol"
                        :wrapperCol="wrapperCol"
                    >
                        <a-input style="width: 100%" placeholder="输入数据项名称"
                                 v-decorator="['name', {rules: [{required: true, min:1, message: '请输入数据项名称！'}]}]"/>
                        <a-input style="display: none" type="hidden" v-decorator="['id',{}]"/>
                    </a-form-item>
                    <a-form-item
                        label="起始位"
                        :labelCol="labelCol"
                        :wrapperCol="wrapperCol"
                    >
                        <a-input-number style="width: 100%" placeholder="输入起始位" @blur="handlerExampleData"
                                 v-decorator="['start', {rules: [{required: true, message: '请输入起始位！'}]}]"/>
                    </a-form-item>
                    <a-form-item
                        label="数据长度"
                        :labelCol="labelCol"
                        :wrapperCol="wrapperCol"
                    >
                        <a-input-number style="width: 100%" placeholder="输入数据长度" @blur="handlerExampleData"
                                 v-decorator="['length', {rules: [{required: true, message: '请输入数据长度！'}]}]"/>
                    </a-form-item>
                    <a-divider>数据解析</a-divider>
                    <a-form-item
                        label="数据示例"
                        :labelCol="labelCol"
                        :wrapperCol="wrapperCol"
                    >
                        <span>{{computeData.left}}</span>
                        <a-input style="width: 85px;text-align: center;margin: 0 5px" v-model="computeData.data"/>
                        <span>{{computeData.right}}</span>
                    </a-form-item>
                    <a-form-item
                        label="高低位转换"
                        :labelCol="labelCol"
                        :wrapperCol="wrapperCol">
                        <a-input style="display: none" type="hidden" v-decorator="['highLowConvert',{initialValue:0}]"/>
                        <a-radio-group :options="[{label:'不转换',value:0},{label:'转换',value:1}]" @change="changeHighLowConvert"
                                       :value="highLowConvert"/>
                    </a-form-item>
                    <a-form-item
                        label="转换至"
                        :labelCol="labelCol"
                        :wrapperCol="wrapperCol"
                    >
                        <a-select v-decorator="['convertTo', {initialValue:1,rules: [{required: true, message: '请选择转换至类型！'}]}]">
                            <a-select-option :value="1">整数</a-select-option>
                            <a-select-option :value="2">浮点数</a-select-option>
                            <a-select-option :value="3">二进制</a-select-option>
                        </a-select>
                    </a-form-item>
                    <a-form-item
                        label="数据切割"
                        :labelCol="labelCol"
                        :wrapperCol="wrapperCol">
                        <a-input style="display: none" type="hidden" v-decorator="['cut',{initialValue:0}]"/>
                        <a-radio-group :options="[{label:'不切割',value:0},{label:'切割',value:1}]" @change="changeCut"
                                       :value="cut"/>
                    </a-form-item>
                    <a-form-item v-if="cut"
                                 label="切割起始位"
                                 :labelCol="labelCol"
                                 :wrapperCol="wrapperCol"
                    >
                        <a-input-number style="width: 100%" placeholder="输入起始位"
                                        v-decorator="['cutStart', {rules: [{required: true, message: '请输入切割起始位！'}]}]"/>
                    </a-form-item>
                    <a-form-item v-if="cut"
                                 label="切割长度"
                                 :labelCol="labelCol"
                                 :wrapperCol="wrapperCol"
                    >
                        <a-input-number style="width: 100%" placeholder="输入数据长度"
                                        v-decorator="['cutLength', {rules: [{required: true, message: '请输入切割长度！'}]}]"/>
                    </a-form-item>
                    <a-form-item
                                 label="计算结果"
                                 :labelCol="labelCol"
                                 :wrapperCol="wrapperCol"
                    >
                        <span style="position: relative;top: -3px;margin-right: 10px;border: 1px solid #ccc;display: inline-block;border-radius: 3px;height: 30px;vertical-align: middle;line-height: 30px;padding: 0 10px;width: 100px" v-text="computeData.result"></span>
                        <a-button type="default" @click="parseData" :loading="parseLoading">计算</a-button>
                    </a-form-item>
                    <a-divider>数据预警</a-divider>
                    <a-form-item
                        label="数据预警"
                        :labelCol="labelCol"
                        :wrapperCol="wrapperCol">
                        <a-input style="display: none" type="hidden" v-decorator="['dataWarn',{initialValue:0}]"/>
                        <a-radio-group :options="[{label:'不预警',value:0},{label:'预警',value:1}]" @change="changeDataWarn"
                                       :value="dataWarn"/>
                    </a-form-item>
                    <a-form-item v-if="dataWarn"
                        label="对比选项"
                        :labelCol="labelCol"
                        :wrapperCol="wrapperCol">
                        <a-radio-group name="radioGroup" :default-value="1" v-decorator="['warnOption',{initialValue:1}]">
                            <a-radio :value="1">等于</a-radio>
                            <a-radio :value="2">大于等于</a-radio>
                            <a-radio :value="3">小于等于</a-radio>
                        </a-radio-group>
                    </a-form-item>
                    <a-form-item v-if="dataWarn"
                        label="预警值"
                        :labelCol="labelCol"
                        :wrapperCol="wrapperCol">
                        <a-input style="width: 100%" placeholder="输入预警值"
                                 v-decorator="['warnValue', {rules: [{required: true, message: '请输入预警值！'}]}]"/>
                    </a-form-item>
                    <a-form-item v-if="dataWarn"
                        label="预警方式"
                        :labelCol="labelCol"
                        :wrapperCol="wrapperCol">
                        <a-checkbox-group :options="warnTypeList" v-model="warnType"></a-checkbox-group>
                    </a-form-item>
                    <a-form-item v-if="dataList.length"
                        label="选择关联数据"
                        :labelCol="labelCol"
                        :wrapperCol="wrapperCol"
                    >
                        <a-select v-decorator="['bindData', {}]">
                            <a-select-option :value="item.id" v-for="item in dataList" :key="item.id">
                                {{item.name}}
                            </a-select-option>
                        </a-select>
                    </a-form-item>
                </a-form>
            </a-spin>
        </a-modal>
    </div>
</template>

<script>
    import {mapGetters} from 'vuex'
    import api from '@/api'

    const columns = [{
        title: 'id',
        dataIndex: 'id',
    }, {
        title: '数据项名称',
        dataIndex: 'name',
    }, {
        title: '指令名称',
        dataIndex: 'instructName',
    }, {
        title: '起始位',
        dataIndex: 'start',
    },{
        title: '数据长度',
        dataIndex: 'length',
    },{
        title: '操作',
        dataIndex: 'control',
        scopedSlots: {customRender: 'control'},
    }]
    export default {
        props:{
            goNext:{
                type:Function,
                default:null
            },
            pid:{
                type:Number,
                default:0
            },
            retExample:{
                type:String,
                default:''
            }
        },
        data(){
            return {
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
                type: 0,
                computeData:{},
                highLowConvert: 0,
                cut:0,
                dataWarn:0,
                parseLoading:false,
                warnType:[1],
                warnTypeList:[{value:1,label:'平台弹框',checked:true},{value:2,label:'APP推送',checked:false}],
                dataList:[]
            }
        },
        computed: {
            ...mapGetters(['color'])
        },
        mounted() {
            if (!this.isHasPermission()('connectEquipment.equipment.dataList')) {
                return
            }
            this.loadData();
            this.handlerExampleData()
            this.getCurInstruct()
        },
        methods: {
            ...mapGetters(['isHasPermission']),
            getCurInstruct(){
                this.$http.post(api.equipment.getDataListByInstructId,{id:this.pid}).then(res => {
                    if(res.code == 0){
                        this.dataList = res.list ? res.list : []
                    }else{
                        this.$message.error(res.msg)
                    }
                }).catch(err => {
                    console.log(err)
                })
            },
            parseData(){
                let data = this.computeData.data
                if(data){
                    const {form: {validateFields}} = this
                    this.parseLoading = true
                    validateFields((errors, values) => {
                        if(errors){
                            this.confirmLoading = false
                            return
                        }
                        values.retExample = this.computeData.left + data + this.computeData.right
                        this.$http.post(api.equipment.parseData, values).then(res => {
                            if(res.code == 0){
                                this.computeData.result = res.result
                            }else{
                                this.$message.error(res.msg)
                            }
                            this.parseLoading = false
                        }).catch(err => {
                            console.log(err)
                        })
                    })
                }else{
                    this.$message.warning('没有示例返回数据')
                }
            },
            changeCut(e) {
                let val = e.target.value
                this.form.setFieldsValue({'cut': val})
                this.cut = val
            },
            changeDataWarn(e) {
                let val = e.target.value
                this.form.setFieldsValue({'dataWarn': val})
                this.dataWarn = val
            },
            changeHighLowConvert(e) {
                let val = e.target.value
                this.form.setFieldsValue({'highLowConvert': val})
                this.highLowConvert = val
            },
            goNextStep(step,record){
                this.goNext(step,record)
            },
            handlerExampleData(){
                let data = this.retExample
                let start = this.form.getFieldValue('start')
                let length = this.form.getFieldValue('length')
                if(data && start + '' && length){
                    this.computeData = {
                        left:data.substring(0,start),
                        data:data.substring(start,start + length),
                        right:data.substring(start+length)
                    }
                }else{
                    this.computeData = {}
                }
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
            changeType(e) {
                let val = e.target.value
                this.form.setFieldsValue({'type': val})
                this.type = val
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
                this.queryData.pid = this.pid
                this.$http.post(api.equipment.dataList, this.queryData).then(res => {
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
                that.highLowConvert = record.highLowConvert
                that.cut = record.cut
                that.dataWarn = record.dataWarn
                setTimeout(() => {
                    setFieldsValue(record)
                    that.handlerExampleData()
                }, 0)
            },
            addRecord() {
                this.form.resetFields()
                this.visible = true
                this.highLowConvert = 0
                this.cut = 0
                this.dataWarn = 0
                this.warnType = [1]
            },
            handleSubmit() {
                const {form: {validateFields}} = this
                this.confirmLoading = true
                validateFields((errors, values) => {
                    if(errors){
                        this.confirmLoading = false
                        return
                    }
                    values.instructId = this.pid
                    if(values.dataWarn){
                        values.warnType = this.warnType.join(',')
                    }
                    this.$http({
                        url: api.equipment.dataSaveOrUpdate,
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
                                url: api.equipment.dataDelete,
                                method: 'post',
                                headers: {
                                    send: 'json'
                                },
                                data: arr
                            }).then(res => {
                                if (res.code == 0) {
                                    self.$message.success('删除成功！')
                                    self.selectedItems = []
                                    self.selectedRowKeys = []
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

<style scoped>

</style>