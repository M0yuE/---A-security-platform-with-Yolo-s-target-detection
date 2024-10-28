package com.antd.modules.security.service;

import com.antd.common.utils.PageUtils;
import com.antd.common.utils.Query;
import com.antd.modules.security.connect.ChannelAttr;
import com.antd.modules.security.connect.NettyConstant;
import com.antd.modules.security.connect.NettyTCPServer;
import com.antd.modules.security.connect.NettyUDPServer;
import com.antd.modules.security.dao.SecConnectDao;
import com.antd.modules.security.entity.SecConnect;
import com.antd.modules.security.entity.SecConnectModular;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import io.netty.channel.Channel;
import io.netty.channel.ChannelHandlerContext;
import io.netty.util.Attribute;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Service
//extends ServiceImpl 就会封装很多常用的数据库操作
//public class泛型中的 SecConnectDao是Dao类，用于访问数据库以执行实际操作；SecConnect 是实体类，它将会映射到数据库中对应的表。
public class SecConnectService extends ServiceImpl<SecConnectDao, SecConnect> {
    public PageUtils queryPage(Map<String, Object> params) {
        String paramKey = (String)params.get("name");
        IPage<SecConnect> page = this.page(
                new Query<SecConnect>().getPage(params),
                new QueryWrapper<SecConnect>()
                        .like(StringUtils.isNotBlank(paramKey),"name", paramKey)
        );
        List<SecConnect> records = page.getRecords();
        List<Channel> serverList = NettyConstant.SERVER_LIST;
        for(Channel channel : serverList){
            Attribute<ChannelAttr> attr = channel.attr(NettyConstant.CTX_INFO);
            ChannelAttr ca = attr.get();
            List<ChannelHandlerContext> childrenCtxs = ca.getChildrenCtxs();
            List<SecConnectModular> upModularList = new ArrayList<>();
            for(ChannelHandlerContext ctx : childrenCtxs){
                ChannelAttr channelAttr = ctx.channel().attr(NettyConstant.CTX_INFO).get();
                if(channelAttr != null){
                    upModularList.add(channelAttr.getSecConnectModular());
                }
            }
            int i = records.indexOf(ca.getSecConnect());
            records.get(i).setStatus(1);
            if(upModularList.size() > 0){
                records.get(i).setUpModularList(upModularList);
            }
        }
        return new PageUtils(page);
    }
    public void saveOrUpdateConnect(SecConnect secConnect){
        Integer id = secConnect.getId();
        if(id != null){
            SecConnect old = this.getById(id);
            if(!old.getPort().equals(secConnect.getPort())){
                NettyConstant.stopPort(old.getPort());
            }
            this.updateById(secConnect);
        }else{
            this.save(secConnect);
        }
        //10666、12888端口被设置为烟雾数据和视频流的端口，不能开放
        if(secConnect.getType() == 1 && secConnect.getPort()!= 12888 && secConnect.getPort()!= 10666){
            NettyTCPServer.run(secConnect);
        }else if(secConnect.getType() == 2){
            NettyUDPServer.run(secConnect);
        }
    }
    @Transactional
    public void deleteConnect(Long[] ids){
        List<Long> longs = Arrays.asList(ids);
        Collection<SecConnect> secConnects = this.listByIds(longs);
        for(SecConnect secConnect : secConnects){
            NettyConstant.stopPort(secConnect.getPort());
        }
        this.removeByIds(longs);
    }
    public List<SecConnect> getAllConnectWithCount(){
        return baseMapper.getAllConnectWithCount();
    }
}
