<template>
    <div>
        <ckeditor style="line-height: normal;background: #fff;min-height: 300px;border: 1px solid #ccc;border-top: none;" @ready="onReady" :editor="editor" v-model="editorData" :config="editorConfig"></ckeditor>
    </div>
</template>

<script>
    import DecoupledEditor from '@ckeditor/ckeditor5-build-decoupled-document';
    import '@ckeditor/ckeditor5-build-decoupled-document/build/translations/zh-cn'
    import UploadImageAdapter from '../../utils/ckEditorUploadAdapter'
    export default {
        data(){
            return{
                editor:DecoupledEditor,
                editorData:'',
                editorConfig:{
                    language: 'zh-cn',//中文包
                    placeholder:'请输入内容',
                    fontSize: {
                        options: [8, 10, 'default', 14, 16, 18, 20, 22, 24, 26, 28, 32, 48]
                    },
                    fontFamily: {
                        options: ["宋体", "仿宋", "微软雅黑", "黑体", "仿宋_GB2312", "楷体", "隶书", "幼圆"]
                    },
                    toolbar:{
                        shouldNotGroupWhenFull:true
                    },
                }
            }
        },
        methods:{
            onReady(editor){
                editor.ui.getEditableElement().parentElement.insertBefore(
                    editor.ui.view.toolbar.element,
                    editor.ui.getEditableElement()
                )
                editor.plugins.get("FileRepository").createUploadAdapter = loader => {
                    return new UploadImageAdapter(this, loader)
                }
            }
        }
    }
</script>

<style scoped>
    #preview-container{
        padding: 5px;
    }
</style>