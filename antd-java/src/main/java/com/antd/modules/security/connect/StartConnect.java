package com.antd.modules.security.connect;

import com.antd.modules.security.entity.SecConnect;
import com.antd.modules.security.service.SecConnectService;
import io.netty.channel.Channel;
import io.netty.util.Attribute;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import java.util.List;

@Component
@Configuration
@EnableScheduling
public class StartConnect {//开启连接，重试未开启的连接
    @Resource
    private SecConnectService secConnectService;
    @PostConstruct
    @Scheduled(cron = "0/30 * * * * ?")
    public void startNetty(){
        List<Channel> serverList = NettyConstant.SERVER_LIST;
        List<SecConnect> list = secConnectService.list();
        for(Channel channel : serverList){
            Attribute<ChannelAttr> attr = channel.attr(NettyConstant.CTX_INFO);
            ChannelAttr ca = attr.get();
            list.remove(ca.getSecConnect());
        }
        for(SecConnect secConnect : list){
            if(secConnect.getType() == 1){
                NettyTCPServer.run(secConnect);
            }else if(secConnect.getType() == 2){
                NettyUDPServer.run(secConnect);
            }
        }
    }
}
