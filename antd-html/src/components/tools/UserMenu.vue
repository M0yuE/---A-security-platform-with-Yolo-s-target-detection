<template>
  <div class="user-wrapper">
    <div class="content-box">
      <!--<a href="https://pro.loacg.com/docs/getting-started" target="_blank">
        <span class="action">
          <a-icon type="question-circle-o"></a-icon>
        </span>
      </a>-->
        <a-badge :count="getWarnCount" v-if="getWarnCount() != 0 && isHasPermission()('secData.warnMsg.list')" style="cursor: pointer;margin-right: 20px" @click="goWarnMsg">
            <span style="display: inline-block;line-height: 20px;padding-right: 6px">警告消息</span>
        </a-badge>
      <!--<notice-icon class="action"/>-->
      <a-dropdown>
        <span class="action ant-dropdown-link user-dropdown-menu">
          <!--<a-avatar class="avatar" size="small" :src="avatar"/>-->
          <span>{{ nickname }}</span>
        </span>
        <a-menu slot="overlay" class="user-dropdown-menu-wrapper">
          <!--<a-menu-item key="0">
            <router-link :to="{ name: 'center' }">
              <a-icon type="user"/>
              <span>个人中心</span>
            </router-link>
          </a-menu-item>
          <a-menu-item key="2" disabled>
            <a-icon type="setting"/>
            <span>测试</span>
          </a-menu-item>
          -->
          <a-menu-item key="1" @click="visible = true">
            <a-icon type="lock"/>
            <span>修改密码</span>
          </a-menu-item>
          <a-menu-divider/>
          <a-menu-item key="3">
            <a href="javascript:;" @click="handleLogout">
              <a-icon type="logout"/>
              <span>退出登录</span>
            </a>
          </a-menu-item>
        </a-menu>
      </a-dropdown>
      <!--修改密码-->
      <a-modal
              title="修改密码"
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
                    label="原密码"
                    :labelCol="labelCol"
                    :wrapperCol="wrapperCol"
            >
              <a-input type="password" v-decorator="['password', {rules: [{required: true, message: '请输入原密码！'}]}]" />
            </a-form-item>
            <a-form-item
                    label="新密码"
                    :labelCol="labelCol"
                    :wrapperCol="wrapperCol"
            >
              <a-input type="password" v-decorator="['newPassword', {rules: [{validator:checkPass}]}]" />
            </a-form-item>
          </a-form>
        </a-spin>
      </a-modal>
    </div>
  </div>
</template>

<script>
import {mapGetters,mapActions } from 'vuex'
import Vue from 'vue'
import { ACCESS_TOKEN } from '@/store/mutation-types'
import api from '@/api'

export default {
  name: 'UserMenu',
  data(){
    return {
      labelCol: {
        xs: { span: 24 },
        sm: { span: 7 }
      },
      wrapperCol: {
        xs: { span: 24 },
        sm: { span: 13 }
      },
      nickname:'',
      form: this.$form.createForm(this),
      visible: false,
      confirmLoading: false,
    }
  },
    props: {
        websocketClose: {
            type: Function,
            default: null
        }
    },
  mounted(){
    const user = this.getUserInfo()
    this.nickname = user.username
  },
  methods: {
    ...mapActions(['ClearUserInfo']),
    ...mapGetters(['getUserInfo','getWarnCount','isHasPermission']),
      goWarnMsg(){
          this.$router.push({ path: '/secData/warnMsg'})
      },
    checkPass(role,value,callback){
      if(!value || value == ""){
        callback("请输入新密码！")
        return;
      }
      const { form: { getFieldValue } } = this
      const username = getFieldValue('password')
      if(username == value){
        callback("您输入的新密码和旧密码一致！");
        return;
      }
      callback()
    },
    handleSubmit(){
      this.confirmLoading = true
      const { form: { validateFields } } = this
      validateFields((errors, values) => {
        if(!errors){
          this.$http.post(api.updatePassword,values).then(res => {
            if(res.code != 0){
              this.$message.error(res.msg)
            }else{
              this.$message.success("修改密码成功，请重新登陆！")
              this.visible = false
              setTimeout(() => {
                Vue.ls.remove(ACCESS_TOKEN)
                this.ClearUserInfo()
                  this.websocketClose()
                this.$router.push({ path: '/user/login',query: { redirect: this.$route.path }})
              },1000)
            }
            this.confirmLoading = false
          }).catch(err => {
            console.log(err)
          })
        }else{
          this.confirmLoading = false
        }
      })
    },
    handleCancel(){
      this.visible = false
    },
    handleLogout(){
      const that = this
      this.$confirm({
        title: '提示',
        content: '真的要注销登录吗 ?',
        onOk () {
          Vue.ls.remove(ACCESS_TOKEN)
          that.ClearUserInfo()
            that.websocketClose()
          that.$router.push({ path: '/user/login',query: { redirect: that.$route.path }})
        },
        onCancel () {
        }
      })
    },
  }
}
</script>
