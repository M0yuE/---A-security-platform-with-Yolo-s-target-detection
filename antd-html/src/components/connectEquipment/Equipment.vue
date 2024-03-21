<template>
    <a-layout class="main">
        <div>
            <div style="width: 600px;margin: auto;margin-bottom: 10px">
                <a-steps>
                    <a-step :status="step == 0 ? 'process' : 'wait'" title="模块" style="cursor: pointer" @click="goStep(0)">
                    </a-step>
                    <a-step :status="step == 1 ? 'process' : 'wait'" title="设备" style="cursor: pointer" @click="goStep(1)">
                    </a-step>
                    <a-step :status="step == 2 ? 'process' : 'wait'" title="指令" style="cursor: pointer" @click="goStep(2)">
                    </a-step>
                    <a-step :status="step == 3 ? 'process' : 'wait'" title="数据项" style="cursor: pointer" @click="goStep(3)">
                    </a-step>
                </a-steps>
            </div>
            <div>
                <ConnectModular :goNext="goNext" v-if="step == 0"/>
                <Equipments :goNext="goNext" :pid="pid" v-if="step == 1"/>
                <Instruct :goNext="goNext" :pid="pid" v-if="step == 2"/>
                <Data :goNext="goNext" :pid="pid" :retExample="retExample" v-if="step == 3"/>
            </div>
    </div>
    </a-layout>
</template>

<script>
    export default {
        name: "Equipment",
        components: {
            'ConnectModular': () => import('./ConnectModular.vue'),
            'Equipments': () => import('./Equipments.vue'),
            'Instruct': () => import('./Instruct.vue'),
            'Data': () => import('./Data.vue'),
        },
        data(){
            return {
                step:0,
                pid:0,
                idArr:[1,0,0,0],
                nameArr:['模块','设备','指令','数据项'],
                retExample:''
            }
        },
        methods:{
            goNext(step,record){
                this.pid = record.id
                this.step = step
                this.idArr[step] = record.id
                if(record.retExample){
                    this.retExample = record.retExample
                }
            },
            goStep(val){
                if(!this.idArr[val]){
                    this.$message.warning('请选择'+this.nameArr[val - 1])
                    return
                }
                this.pid = this.idArr[val]
                this.step = val
                for(let i = val + 1;i < 4;i++){
                    this.idArr[i] = 0
                }
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