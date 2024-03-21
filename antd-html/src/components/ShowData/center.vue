<template>
    <div class="center">
        <div class="videoLive">
            <img :src="videoUrl" alt="Live Video" class="live-video">
        </div>
    </div>
</template>

<script>
import centerChart from "@/components/echart/center/centerChartRate";
import api from '@/api'

export default {
    data() {
        return {
            videoUrl:'http://127.0.0.1:12888/live',
        };
    },
    components: {
        centerChart
    },
    mounted() {
        this.loadData();
        this.timerMy();
    },
    methods: {
    },
};
</script>

<style lang="scss" scoped>
.center {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;

    .videoLive{
        width: 95%; // 调整 div 宽度
        height: 95%; // 调整 div 高度
    }

    .live-video {
        width: 100%;
        height: 100%;
        object-fit: contain; // 让视频保持长宽比
    }
}
</style>