package com.antd.modules.security.service;

import com.antd.common.utils.PageUtils;
import com.antd.common.utils.Query;
import com.antd.modules.security.dao.SecWarnMsgDao;
import com.antd.modules.security.entity.SecWarnMsg;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.UpdateWrapper;
import com.baomidou.mybatisplus.core.injector.methods.DeleteById;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

@Service
public class SecWarnMsgService extends ServiceImpl<SecWarnMsgDao, SecWarnMsg> {
    @Resource
    private SecWarnMsgDao secWarnMsgDao;
    public PageUtils queryPage(Map<String, Object> params) {
        IPage<SecWarnMsg> page = secWarnMsgDao.queryListPage(new Query<SecWarnMsg>().getPage(params), params);
        return new PageUtils(page);
    }
    public void readMsg(Long[] ids){
        this.update(new UpdateWrapper<SecWarnMsg>().set("is_read", 1).in("id", Arrays.asList(ids)));
    }

    public List<SecWarnMsg> uniQueryDataList() {
        List<SecWarnMsg> secWarnMsgAllList = secWarnMsgDao.uniQueryList();
        return secWarnMsgAllList;
    }
    public List<SecWarnMsg> uniReadWarnMsg(Integer id){
        UpdateWrapper<SecWarnMsg> updateWrapper = new UpdateWrapper<>();
        updateWrapper.lambda().set(SecWarnMsg::getIsRead,1).eq(SecWarnMsg::getId,id);
        this.update(updateWrapper);
        return secWarnMsgDao.uniQueryList();
    }
    public List<SecWarnMsg> uniDeleteWarnMsg(Integer id){
        secWarnMsgDao.deleteById(id);
        return secWarnMsgDao.uniQueryList();
    }
}
