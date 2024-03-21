<template>
    <div id="centreRight1">
        <div class="bg-color-black">
            <div class="d-flex pt-2 pl-2">
                <span style="color:#5cd9e8">
                    <icon name="chart-line"></icon>
                </span>
                <div class="d-flex">
                    <!--          <span class="fs-xl text mx-2">任务完成排行榜</span>-->
                    <span class="fs-xl text mx-2">警告消息展示榜</span>
                </div>
            </div>
            <div class="d-flex jc-center body-box">
                <dv-scroll-board :config="config" style="width:3.375rem;height:4.28rem" />
            </div>
        </div>
    </div>
</template>

<script>
    import api from '@/api'


    export default {
        data() {
            return {
                config: {}
            };
        },
        components: {},
        mounted() {
            this.loadData();
            this.loadDataTime();
        },
        methods: {
            /*从服务器定时获取警告消息的数据*/
            loadDataTime() {
                setInterval(this.loadData, 1200000);//20分钟请求一次服务器拿到数据
            },
            /*从服务器获取警告消息的数据*/
            loadData() {
            //   console.log("执行了====");
                let dataMessagesArray = [];
                this.$http.post(api.data.uniDataWarnMsg).then(res => {
                    if (res.code == 0) {
                        this.dataMessages = res.messages;
                        for (let i = 0; i <= this.dataMessages.length - 1; i++) {
                            dataMessagesArray.push([this.dataMessages[i].equipmentName, this.dataMessages[i].msg]);
                        }
                        this.config = {
                            data: dataMessagesArray,
                            header: ["设备名称", "警告消息"],
                            rowNum: 7, //表格行数
                            headerHeight: 35,
                            headerBGC: "#0f1325", //表头
                            oddRowBGC: "#0f1325", //奇数行
                            evenRowBGC: "#171c33", //偶数行
                            index: true,
                            columnWidth: [20],
                            align: ["center"]
                        } //才是有效的
                    } else {
                        this.$message.error(res.msg)
                    }
                }).catch(err => {
                    console.log(err)
                })
            },
        }
    };
</script>

<style lang="scss">
    #centreRight1 {
        padding: 0.2rem;
        height: 5.125rem;
        min-width: 3.75rem;
        border-radius: 0.0625rem;

        .bg-color-black {
            height: 4.8125rem;
            border-radius: 0.125rem;
        }

        .text {
            color: #c3cbde;
        }

        .body-box {
            border-radius: 0.125rem;
            overflow: hidden;

            .header {
                height: 35px;

            }
        }
    }
</style>