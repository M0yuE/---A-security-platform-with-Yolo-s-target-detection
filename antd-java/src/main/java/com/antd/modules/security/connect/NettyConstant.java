package com.antd.modules.security.connect;

import io.netty.channel.Channel;
import io.netty.util.AttributeKey;

import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

public class NettyConstant {
    public static final AttributeKey<ChannelAttr> CTX_INFO = AttributeKey.valueOf("ctxInfo");
    public static List<Channel> SERVER_LIST =  new CopyOnWriteArrayList();
    public static void stopPort(Integer port){
        for(Channel channel : SERVER_LIST){
            ChannelAttr channelAttr = channel.attr(CTX_INFO).get();
            if(channelAttr.getPort().equals(port)){
                channel.disconnect();
                SERVER_LIST.remove(channel);
            }
        }
    }
}
