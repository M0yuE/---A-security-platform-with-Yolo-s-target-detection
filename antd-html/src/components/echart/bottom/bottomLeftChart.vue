<template>
    <div>
        <div id="bottomLeftChart" style="width:11.25rem;height:6.25rem;"></div>
    </div>
</template>

<script>
    import echartMixins from "@/utils/resizeMixins";
    import api from '@/api';
    export default {
        data() {
            return {
                chart: null,
                category: [],
                lineData: [],
                barData: [],
            };
        },
        mixins: [echartMixins],
        mounted() {
            this.draw();
        },
        methods: {
            draw() {
                // 基于准备好的dom，初始化echarts实例
                this.chart = this.$echarts.init(document.getElementById("bottomLeftChart"));
                this.$http.post(api.data.NodeData).then(res => {
                    if (res.code == 0) {
                        this.category = res.NodeMockData.category;
                        this.lineData = res.NodeMockData.lineData;
                        this.barData = res.NodeMockData.barData;

                        let rateData = [];
                        for (let i = 0; i < 33; i++) {
                            let rate = this.barData[i] / this.lineData[i];
                            rateData[i] = rate.toFixed(2);
                        }

                        let option = {
                            title: {
                                text: "",
                                x: "center",
                                y: 0,
                                textStyle: {
                                    color: "#B4B4B4",
                                    fontSize: 16,
                                    fontWeight: "normal"
                                }
                            },
                            tooltip: {
                                trigger: "axis",
                                backgroundColor: "rgba(255,255,255,0.1)",
                                axisPointer: {
                                    type: "shadow",
                                    label: {
                                        show: true,
                                        backgroundColor: "#7B7DDC"
                                    }
                                }
                            },
                            legend: {
                                data: ["已部署", "计划部署", "部署率"],
                                textStyle: {
                                    color: "#B4B4B4"
                                },
                                top: "0%"
                            },
                            grid: {
                                x: "8%",
                                width: "88%",
                                y: "4%"
                            },
                            xAxis: {
                                data: this.category,
                                axisLine: {
                                    lineStyle: {
                                        color: "#B4B4B4"
                                    }
                                },
                                axisTick: {
                                    show: false
                                }
                            },
                            yAxis: [{
                                    splitLine: {
                                        show: false
                                    },
                                    axisLine: {
                                        lineStyle: {
                                            color: "#B4B4B4"
                                        }
                                    },

                                    axisLabel: {
                                        formatter: "{value} "
                                    }
                                },
                                {
                                    splitLine: {
                                        show: false
                                    },
                                    axisLine: {
                                        lineStyle: {
                                            color: "#B4B4B4"
                                        }
                                    },
                                    axisLabel: {
                                        formatter: "{value} "
                                    }
                                }
                            ],
                            series: [{
                                    name: "部署率",
                                    type: "line",
                                    smooth: true,
                                    showAllSymbol: true,
                                    symbol: "emptyCircle",
                                    symbolSize: 8,
                                    yAxisIndex: 1,
                                    itemStyle: {
                                        normal: {
                                            color: "#F02FC2"
                                        }
                                    },
                                    data: rateData
                                },

                                {
                                    name: "已部署",
                                    type: "bar",
                                    barWidth: 10,
                                    itemStyle: {
                                        normal: {
                                            barBorderRadius: 5,
                                            color: new this.$echarts.graphic.LinearGradient(0, 0, 0, 1,
                                                [{
                                                        offset: 0,
                                                        color: "#956FD4"
                                                    },
                                                    {
                                                        offset: 1,
                                                        color: "#3EACE5"
                                                    }
                                                ])
                                        }
                                    },
                                    data: this.barData
                                },

                                {
                                    name: "计划部署",
                                    type: "bar",
                                    barGap: "-100%",
                                    barWidth: 10,
                                    itemStyle: {
                                        normal: {
                                            barBorderRadius: 5,
                                            color: new this.$echarts.graphic.LinearGradient(0, 0, 0, 1,
                                                [{
                                                        offset: 0,
                                                        color: "rgba(156,107,211,0.8)"
                                                    },
                                                    {
                                                        offset: 0.2,
                                                        color: "rgba(156,107,211,0.5)"
                                                    },
                                                    {
                                                        offset: 1,
                                                        color: "rgba(156,107,211,0.2)"
                                                    }
                                                ])
                                        }
                                    },
                                    z: -12,

                                    data: this.lineData
                                }
                            ]
                        };
                        this.chart.setOption(option);
                    } else {
                        this.$message.error(res.msg)
                    }
                }).catch(err => {
                    console.log(err)
                });
            }
        },
        destroyed() {
            window.onresize = null;
        }
    };
</script>

<style lang="scss" scoped>
</style>