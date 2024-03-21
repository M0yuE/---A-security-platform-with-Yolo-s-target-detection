<template>
    <div class="accept-container">
        <iframe id="show-iframe" frameborder=0 name="showHere" scrolling="auto" :src="dataURL"></iframe>
    </div>
</template>

<script>
    import api from '@/api'
    import Vue from 'vue'
    import {ACCESS_TOKEN} from '@/store/mutation-types'

    let token = Vue.ls.get(ACCESS_TOKEN)
    export default {
        name: 'Sql',
        data() {
            return {
                dataURL: api.sql.html + "?token=" + token
            }
        },
        mounted() {
            const oIframe = document.getElementById('show-iframe');
            const deviceWidth = document.documentElement.clientWidth;
            const deviceHeight = document.documentElement.clientHeight;
            oIframe.style.width = (Number(deviceWidth) - 280) + 'px'; //数字是页面布局宽度差值
            oIframe.style.height = (Number(deviceHeight)) + 'px'; //数字是页面布局高度差
        },
        methods: {}
    }
</script>

<style>

</style>