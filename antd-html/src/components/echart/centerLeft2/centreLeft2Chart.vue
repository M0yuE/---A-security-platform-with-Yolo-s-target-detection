<template>
  <div>
    <div id="centreLeft2Chart" style="width:4.5rem; height: 4rem;"></div>
  </div>
</template>

<script>
import echartMixins from "@/utils/resizeMixins";
import {axios} from "@/utils/request";

export default {
  data() {
    return {
        chart: null,
        timer: null,
        smokeValue:5,
    };
  },
  mixins: [echartMixins],
  mounted() {
    this.draw();
  },
  methods: {
    draw() {
      // 基于准备好的dom，初始化echarts实例
      this.chart = this.$echarts.init(document.getElementById("centreLeft2Chart"));
      //  ----------------------------------------------------------------
      let option = {
          series: [
              {
                  type: 'gauge',
                  startAngle: 180,
                  endAngle: 0,
                  min: 0,
                  max: 1000,
                  splitNumber: 4,
                  itemStyle: {
                      color: '#f35cf8', //进度条颜色
                      shadowColor: 'rgba(0,138,255,0.45)',
                      shadowBlur: 10,
                      shadowOffsetX: 2,
                      shadowOffsetY: 2
                  },
                  progress: {
                      show: true,
                      roundCap: true,
                      width: 18,
                  },
                  pointer: {
                      icon: 'path://M2090.36389,615.30999 L2090.36389,615.30999 C2091.48372,615.30999 2092.40383,616.194028 2092.44859,617.312956 L2096.90698,728.755929 C2097.05155,732.369577 2094.2393,735.416212 2090.62566,735.56078 C2090.53845,735.564269 2090.45117,735.566014 2090.36389,735.566014 L2090.36389,735.566014 C2086.74736,735.566014 2083.81557,732.63423 2083.81557,729.017692 C2083.81557,728.930412 2083.81732,728.84314 2083.82081,728.755929 L2088.2792,617.312956 C2088.32396,616.194028 2089.24407,615.30999 2090.36389,615.30999 Z',
                      length: '55%',
                      width: 4,
                      offsetCenter: [0, '5%']
                  },
                  axisLine: {
                      roundCap: true,
                      lineStyle: {
                          width: 18
                      }
                  },
                  axisTick: {
                      splitNumber: 5,
                      lineStyle: {
                          width: 2,
                          color: '#999'
                      }
                  },
                  splitLine: {
                      length: 12,
                      lineStyle: {
                          width: 3,
                          color: '#999'
                      }
                  },
                  axisLabel: {
                      distance: 20,
                      color: '#999',
                      fontSize: 16
                  },
                  title: {
                      show: false
                  },
                  detail: {
                      // backgroundColor: '#fff',
                      // borderColor: '#999',
                      // borderWidth: 2,
                      width: '190%',
                      lineHeight: 150,
                      height: 40,
                      borderRadius: 8,
                      offsetCenter: [0, '15%'],
                      valueAnimation: true,
                      formatter: function (value) {
                          return ' {value|' + 'AIR : ' + value.toFixed(0) + '} ';
                      },
                      rich: {
                          value: {
                              fontSize: 40,
                              fontWeight: 'bolder',
                              color: '#02f1df' //数值
                          },
                          unit: {
                              fontSize: 20,
                              color: '#999',
                              padding: [0, 0, -20, 10]
                          }
                      }
                  },
                  data: [
                      {
                          value: 0
                      }
                  ]
              }
          ]
      };


        // 模拟值
    this.timer = setInterval(() => {
    // somkeValue = +(Math.random() * 1000).toFixed(2);
    axios.get("http://192.168.43.111:10666/smoke" , { //端口注意
        timeout: 2000,
    }).then(response => {
        this.smokeValue = response.int //发送来的格式是{"int" : val}
    })
    .catch(error => {
        console.error("Error Data Of ESP8266:",error)
    })
    // console.log(this.smokeValue)
    this.chart.setOption({
        series: [
            {
                data: [
                    {
                        value: this.smokeValue
                    }
                ]
            },
        ],
    });
},800);

      this.chart.setOption(option);
    }
  },
  destroyed() {
    window.onresize = null;
  }
};
</script>

<style lang="scss" scoped>
</style>









