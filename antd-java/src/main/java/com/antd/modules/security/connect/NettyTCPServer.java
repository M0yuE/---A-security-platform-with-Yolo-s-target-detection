package com.antd.modules.security.connect;

import com.alibaba.fastjson.JSON;
import com.antd.common.utils.SpringContextUtils;
import com.antd.modules.security.dao.SecConnectModularDao;
import com.antd.modules.security.entity.SecConnect;
import com.antd.modules.security.entity.SecConnectModular;
import com.antd.modules.security.entity.SecData;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import io.netty.bootstrap.ServerBootstrap;
import io.netty.buffer.ByteBuf;
import io.netty.buffer.ByteBufUtil;
import io.netty.channel.*;
import io.netty.channel.nio.NioEventLoopGroup;
import io.netty.channel.socket.SocketChannel;
import io.netty.channel.socket.nio.NioServerSocketChannel;
import io.netty.handler.codec.ByteToMessageDecoder;
import io.netty.util.Attribute;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class NettyTCPServer {
    private static Logger logger = LoggerFactory.getLogger(NettyTCPServer.class);
    public static NioEventLoopGroup bossGroup = new NioEventLoopGroup();
    public static NioEventLoopGroup workerGroup = new NioEventLoopGroup();
    static ServerBootstrap b = new ServerBootstrap();
    static{
        b.group(bossGroup, workerGroup)
                .channel(NioServerSocketChannel.class)
                .option(ChannelOption.SO_BACKLOG,1024)
                .childHandler(new ChannelInitializer<SocketChannel>() {
                    @Override
                    protected void initChannel(SocketChannel ch) throws Exception {
                        ch.pipeline().addLast(new ServerDecoder());
                        ch.pipeline().addLast(new ServerMessageHandler());
                    }
                });
    }
    public static void run(SecConnect connect) {
        logger.info("启动TCP服务端连接："+connect.getPort());
        try {
            b.bind(connect.getPort()).addListener((ChannelFutureListener) future  -> {
                boolean success = future.isSuccess();
                Channel channel = future.channel();
                boolean isOpen = channel.isOpen();
                if(success && isOpen){//开启成功
                    ChannelAttr attr = new ChannelAttr();
                    attr.setSecConnect(connect);
                    attr.setPort(connect.getPort());
                    attr.setOpen(isOpen);
                    attr.setType(1);
                    attr.setActive(channel.isActive());
                    attr.setCtxId(channel.id().asShortText());
                    attr.setThreadName(Thread.currentThread().getName()+"--->"+Thread.currentThread().getId());
                    Attribute<ChannelAttr> channelAttr = channel.attr(NettyConstant.CTX_INFO);
                    channelAttr.set(attr);
                    NettyConstant.SERVER_LIST.add(channel);
                }else{
                    channel.close();
                }
            });
        }catch (Exception e){
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        String strData = "@aabb@\r\n";
        Pattern c = Pattern.compile("@.*?@");
        Matcher m = c.matcher(strData);
        if(m.find()){
            System.out.println(m.group());
        }
    }
}
class ServerDecoder extends ByteToMessageDecoder {
    private Logger logger = LoggerFactory.getLogger(getClass());

    @Override
    protected void decode(ChannelHandlerContext ctx, ByteBuf in, List<Object> out) {
        try {
            // 读取原始数据串 不会改变ByteBuf 索引
            byte[] bytes = new byte[in.readableBytes()];
            in.readBytes(bytes);
            String strData = new String(bytes);//开头结尾使用@符号包围
            RedisTemplate<String, Object> redisTemplate = (RedisTemplate<String, Object>) SpringContextUtils.getBean("redisTemplate");
            Pattern c = Pattern.compile("@.*?@");
            Matcher m = c.matcher(strData);
            //modular:abcd(模块信息) modular:modularId:0001(指令下数据项list)
            if(m.find()){
                strData = m.group();
                ChannelAttr parAttr = ctx.channel().parent().attr(NettyConstant.CTX_INFO).get();
                String key = "modular:" + parAttr.getSecConnect().getId() + ":" +strData.substring(1, strData.length() - 1);
                SecConnectModular modular = (SecConnectModular) redisTemplate.opsForValue().get(key);
                if(modular != null){
                    modular.setIsUp(1);
                    redisTemplate.opsForValue().set(key,modular);
                    ResultData resultData = new ResultData();
                    resultData.setModularUp(true);
                    resultData.setSecConnectModular(modular);
                    out.add(resultData);
                }
            }else{
                in.resetReaderIndex();
                String originalData = ByteBufUtil.hexDump(in).toLowerCase();
                logger.info("当次包数据-->" + originalData);
                while(originalData.length() >= 10){
                    String cmdId = originalData.substring(0,4);
                    ChannelAttr channelAttr = ctx.channel().attr(NettyConstant.CTX_INFO).get();
                    if(channelAttr == null){
                        break;
                    }
                    SecConnectModular modular = channelAttr.getSecConnectModular();
                    String key = "modularInstruct:"+modular.getConnectId()+":"+modular.getId()+":"+cmdId;
                    List<SecData> dataList = (List<SecData>) redisTemplate.opsForValue().get(key);
                    if(dataList == null){
                        logger.info("数据无效-->"+originalData);
                        break;
                    }
                    int length = 0;
                    if(dataList.size() > 0){
                        length = dataList.get(0).getRetExample().length();
                    }
                    String shouldHandlerData = originalData.substring(0,length);
                    for(SecData data : dataList){
                        ResultData resultData = new ResultData();
                        resultData.setData(shouldHandlerData);
                        resultData.setSecData(data);
                        out.add(resultData);
                    }
                    originalData = originalData.substring(length);
                }
            }
            in.skipBytes(in.readableBytes());
        }catch (Exception e){
            e.printStackTrace();
            in.skipBytes(in.readableBytes());
            logger.error("数据异常:"+e.getMessage());
        }
    }
}
class ServerMessageHandler extends ChannelInboundHandlerAdapter {
    @Override
    public void exceptionCaught(ChannelHandlerContext ctx, Throwable cause){
        System.out.println("关闭客户端连接");
        cause.printStackTrace();
    }

    @Override
    public void channelActive(ChannelHandlerContext ctx) throws Exception {
        Attribute<ChannelAttr> attr = ctx.channel().parent().attr(NettyConstant.CTX_INFO);
        ChannelAttr channelAttr = attr.get();
        if(channelAttr != null){
            SecConnect secConnect = channelAttr.getSecConnect();
            int single = secConnect.getSingle();
            if(single == 1){
                SecConnectModularDao modularDao = (SecConnectModularDao) SpringContextUtils.getBean("secConnectModularDao");
                SecConnectModular secConnectModular = modularDao.selectOne(new QueryWrapper<SecConnectModular>().eq("connect_id", secConnect.getId()).last("limit 1"));
                if(secConnectModular != null){
                    secConnectModular.setIsUp(1);
                    modularUp(secConnectModular,ctx);
                }
            }
        }
        super.channelActive(ctx);
    }
    private void modularUp(SecConnectModular modular,ChannelHandlerContext ctx){
        Attribute<ChannelAttr> parAttr = ctx.channel().parent().attr(NettyConstant.CTX_INFO);
        ChannelAttr parChannelAttr = parAttr.get();
        Attribute<ChannelAttr> attr = ctx.channel().attr(NettyConstant.CTX_INFO);
        ChannelAttr childChannelAttr = new ChannelAttr();
        childChannelAttr.setSecConnectModular(modular);
        attr.set(childChannelAttr);
        List<ChannelHandlerContext> childrenCtxs = parChannelAttr.getChildrenCtxs();
        boolean flag = true;
        for(ChannelHandlerContext ct : childrenCtxs){
            ChannelAttr channelAttr = ct.channel().attr(NettyConstant.CTX_INFO).get();
            SecConnectModular secConnectModular = channelAttr.getSecConnectModular();
            if(modular.getId().equals(secConnectModular.getId()) && !ct.channel().id().asShortText().equals(ctx.channel().id().asShortText())){//强行下线
                ct.disconnect();
                childrenCtxs.remove(ct);
                flag = false;
            }
        }
        if(flag){
            childrenCtxs.add(ctx);
            ThreadPoolTaskExecutor exe = (ThreadPoolTaskExecutor) SpringContextUtils.getBean("asyncServiceExecutor");
            exe.submit(new SendMsg(ctx,"服务端"));
        }
        Map<String,Object> socketMsg = new HashMap<>();
        socketMsg.put("type",1);
        socketMsg.put("modular",modular);
        SysWebSocket.sendInfo(JSON.toJSONString(socketMsg));
    }
    @Override
    public void channelInactive(ChannelHandlerContext ctx) throws Exception {
        Channel parentChannel = ctx.channel().parent();
        Attribute<ChannelAttr> attr = parentChannel.attr(NettyConstant.CTX_INFO);
        ChannelAttr parChannelAttr = attr.get();
        List<ChannelHandlerContext> childrenCtxs = parChannelAttr.getChildrenCtxs();
        Attribute<ChannelAttr> childAttr = ctx.channel().attr(NettyConstant.CTX_INFO);
        ChannelAttr channelAttr = childAttr.get();
        if(channelAttr != null){
            SecConnectModular secConnectModular = channelAttr.getSecConnectModular();
            RedisTemplate<String, Object> redisTemplate = (RedisTemplate<String, Object>) SpringContextUtils.getBean("redisTemplate");
            String key = "modular:"+secConnectModular.getConnectId()+":"+secConnectModular.getVerify();
            secConnectModular = (SecConnectModular) redisTemplate.opsForValue().get(key);
            if(secConnectModular != null){
                secConnectModular.setIsUp(0);
                redisTemplate.opsForValue().set(key,secConnectModular);
                Map<String,Object> socketMsg = new HashMap<>();
                socketMsg.put("type",1);
                socketMsg.put("modular",secConnectModular);
                SysWebSocket.sendInfo(JSON.toJSONString(socketMsg));
            }
            for(ChannelHandlerContext context : childrenCtxs){//从serverCtx的属性中剔除子连接对象
                if(ctx.channel().id().asShortText().equals(context.channel().id().asShortText())){
                    childrenCtxs.remove(context);
                    break;
                }
            }
        }
        super.channelInactive(ctx);
    }

    @Override
    public void channelRead(ChannelHandlerContext ctx, Object msg) throws Exception {
        ResultData resultData = (ResultData) msg;
        if(resultData.isModularUp()){
            modularUp(resultData.getSecConnectModular(),ctx);
            return;
        }
        HandlerDataService handlerDataService = (HandlerDataService) SpringContextUtils.getBean("handlerDataService");
        handlerDataService.handlerData(resultData);
    }
}

