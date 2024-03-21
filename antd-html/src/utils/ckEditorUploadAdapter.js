import api from '@/api'
export default class UploadImageAdapter{
    constructor(vue,loader){
        this.vm = vue
        this.loader = loader
    }
    async upload(){
        const img = await this.loader.file
        return new Promise((resolve,reject) => {
            if(img.size > 3145728){
                this.vm.$message.warning(img.name+'大于3M已跳过上传！')
                reject()
                return
            }
            let param = new FormData()
            param.append("file",img)
            this.vm.$http.post(api.shop.upload.oneImage,param,{
                headers: { "Content-Type": "multipart/form-data",send:'file'}
            }).then(res => {
                if(res.code == 0){
                    resolve({
                        default:'/image'+res.result
                    })
                }else{
                    this.vm.$message.error(res.msg)
                    reject()
                }
            }).catch(err => {
                console.log(err)
            })
        })
    }
}