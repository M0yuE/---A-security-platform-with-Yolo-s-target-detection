<template>
    <div id="index">
        <dv-full-screen-container class="bg">
            <dv-loading v-if="loading">Loading...</dv-loading>
            <div v-else class="host-body">
                <div class="d-flex jc-center">
                    <span class="My_back" @click="My_back">◀返回</span>
                    <dv-decoration-10 style="width:33.3%;height:.0625rem;" />
                    <div class="d-flex jc-center">
                        <dv-decoration-8 :color="['#568aea', '#000000']" style="width:2.5rem;height:.625rem;" />
                        <div class="title">
                            <span class="title-text">智慧安防云平台</span>
                            <dv-decoration-6 class="title-bototm" :reverse="true" :color="['#50e3c2', '#67a1e5']"
                                style="width:3.125rem;height:.1rem;" />
                        </div>
                        <dv-decoration-8 :reverse="true" :color="['#568aea', '#000000']"
                            style="width:2.5rem;height:.625rem;" />
                    </div>
                    <dv-decoration-10 style="width:33.3%;height:.0625rem; transform: rotateY(180deg);" />
                </div>

                <!-- 第二行 -->
                <div class="d-flex jc-between px-2">
                    <div class="d-flex" style="width: 40%">
                        <div class="react-right ml-4"
                            style="width: 6.25rem; text-align: left;background-color: #0f1325;">
                            <span class="react-before"></span>
                            <span class="text">综合分析</span>
                        </div>
                        <div class="react-right ml-3" style="background-color: #0f1325;">
                            <span class="text colorBlue">数据分析</span>
                        </div>
                    </div>
                    <div style="width: 40%" class="d-flex">
                        <div class="react-left bg-color-blue mr-3">
                            <span class="text fw-b">王剑雄老师研究团队</span>
                        </div>
                        <div class="react-left mr-4"
                            style="width: 6.25rem; background-color: #0f1325; text-align: right;">
                            <span class="react-after"></span>
                            <!-- <span class="text">2020年03月16日 周一 12:00</span> -->
                            <span class="text-time">{{nowDate}}</span>
                        </div>
                    </div>
                </div>

                <div class="body-box">
                    <!-- 第三行数据 -->
                    <div class="content-box">
                        <div>
                            <dv-border-box-12>
                                <centerLeft1 />
                            </dv-border-box-12>
                        </div>
                        <div>
                            <dv-border-box-12>
                                <centerLeft2 />
                            </dv-border-box-12>
                        </div>
                        <!-- 中间 -->
                        <div>
                            <center />
                        </div>
                        <!-- 中间 -->
                        <div>
                            <centerRight2 />
                        </div>
                        <div>
                            <dv-border-box-13>
                                <centerRight1 />
                            </dv-border-box-13>
                        </div>
                    </div>

                    <!-- 第四行数据 -->
                    <div class="bototm-box">
                        <dv-border-box-13>
                            <bottomLeft />
                        </dv-border-box-13>
                        <dv-border-box-12>
                            <bottomRight />
                        </dv-border-box-12>
                    </div>
                </div>
            </div>
        </dv-full-screen-container>
    </div>
</template>

<script>
    import centerLeft1 from "./centerLeft1";
    import centerLeft2 from "./centerLeft2";
    import centerRight1 from "./centerRight1";
    import centerRight2 from "./centerRight2";
    import center from "./center";
    import bottomLeft from "./bottomLeft";
    import bottomRight from "./bottomRight";
    export default {
        data() {
            return {
                loading: true,
                nowDate: "", //当前日期
            };
        },
        components: {
            centerLeft1,
            centerLeft2,
            centerRight1,
            centerRight2,
            center,
            bottomLeft,
            bottomRight
        },
        mounted() {
            this.cancelLoading();

            this.currentTime();
        },
        beforeDestroy() {
            if (this.getCurrentTime) {
                clearInterval(this.getCurrentTime); // 在Vue实例销毁前，清除时间定时器
            }
        },
        methods: {
            //修改当前日期的
            currentTime() {
                setInterval(this.getCurrentTime, 500);
            },
            getCurrentTime() {
                //获取当前时间并打印
                var _this = this;
                let yy = new Date().getFullYear();
                let mm = new Date().getMonth() + 1;
                let dd = new Date().getDate();
                let hh = new Date().getHours();
                let mf = new Date().getMinutes() < 10 ? '0' + new Date().getMinutes() : new Date().getMinutes();
                let ss = new Date().getSeconds() < 10 ? '0' + new Date().getSeconds() : new Date().getSeconds();
                _this.gettime = yy + '/' + mm + '/' + dd + ' ' + hh + ':' + mf + ':' + ss;
                this.nowDate = _this.gettime
                // console.log(_this.gettime)
            },



            cancelLoading() {
                setTimeout(() => {
                    this.loading = false;
                }, 500);
            },

            My_back() {
                this.$router.go(-1);
            }
        }
    };
</script>

<style lang="scss">
    @import "src/assets/scss/showData";

    .My_back {
        width: 80px;
        height: 30px;
        font-weight: 500;
        // background-color: #fff;
        float: left;
        font-size: 15px;
        padding-top: 10px;

    }

    .text-time {
        display: inline-block;
        transform: skewX(45deg);
        font-size: 20px;
        font-weight: 400;
        // background-color: chartreuse;
        position: absolute;
        left: 80px;
        top: 1px;
    }
</style>