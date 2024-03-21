package com.antd.modules.security.connect;

import com.antd.modules.security.entity.SecConnect;
import com.antd.modules.security.entity.SecConnectModular;
import io.netty.channel.ChannelHandlerContext;
import lombok.Data;

import java.util.LinkedList;
import java.util.List;

@Data
public class ChannelAttr {
    private String threadName;
    private String localAddress;
    private String remoteAddress;
    private String ctxId;
    private Integer port;
    private Boolean open;
    private Boolean active;
    private SecConnect secConnect;
    private SecConnectModular secConnectModular;
    private Integer type = 1;//1TCP 2 UDP
    private List<ChannelHandlerContext> childrenCtxs = new LinkedList<>();
    private List<ChannelAttr> childrenAttrs = new LinkedList<>();
    private InstructQueue instructQueue;
}
