<template>
    <div class="live-video">
        <img :src="videoUrl" alt="Live Stream">
    </div>
</template>

<script>
export default {
    name: 'LiveVideo',
    data() {
        return {
            videoUrl: 'http://127.0.0.1:12888/live', // 根据你的 Flask 应用地址和端口进行设置
        };
    },
};
</script>

<style scoped>
/* 添加适当的样式（如果需要） */
</style>