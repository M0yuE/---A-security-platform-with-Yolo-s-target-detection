package com.antd.modules.security.connect;

import com.antd.modules.security.entity.SecConnect;
import io.netty.bootstrap.Bootstrap;
import io.netty.buffer.Unpooled;
import io.netty.channel.*;
import io.netty.channel.nio.NioEventLoopGroup;
import io.netty.channel.socket.DatagramPacket;
import io.netty.channel.socket.nio.NioDatagramChannel;
import io.netty.util.Attribute;
import io.netty.util.CharsetUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class NettyUDPServer {
    private static Logger logger = LoggerFactory.getLogger(NettyUDPServer.class);
    public static NioEventLoopGroup bossGroup = new NioEventLoopGroup();
    static Bootstrap b = new Bootstrap();
    static{
        b.group(bossGroup)
                .channel(NioDatagramChannel.class)
                .option(ChannelOption.SO_BROADCAST, true)
                .handler(new ServerHandler());
    }
    public static void run(SecConnect connect) {
        logger.info("启动UDP服务端连接："+connect.getPort());
        try {
            b.bind(connect.getPort()).addListener((ChannelFutureListener) future -> {
                boolean success = future.isSuccess();
                Channel channel = future.channel();
                boolean isOpen = channel.isOpen();
                if(success && isOpen){//开启成功
                    ChannelAttr attr = new ChannelAttr();
                    attr.setSecConnect(connect);
                    attr.setPort(connect.getPort());
                    attr.setOpen(isOpen);
                    attr.setType(2);
                    attr.setActive(channel.isActive());
                    attr.setCtxId(channel.id().asShortText());
                    attr.setThreadName(Thread.currentThread().getName()+"--->"+Thread.currentThread().getId());
                    Attribute<ChannelAttr> channelAttr = channel.attr(NettyConstant.CTX_INFO);
                    channelAttr.set(attr);
                    NettyConstant.SERVER_LIST.add(channel);
                }else{
                    channel.closeFuture();
                }
            });
        }catch (Exception e){
            e.printStackTrace();
        }
    }
}
class ServerHandler extends
        SimpleChannelInboundHandler<DatagramPacket> {
    public void messageReceived(ChannelHandlerContext ctx, DatagramPacket packet)
            throws Exception{
        //利用ByteBuf的toString()方法获取请求消息
        String req=packet.content().toString(CharsetUtil.UTF_8);
        System.out.println(req);
        if("谚语字典查询?".equals(req)){
            //创建新的DatagramPacket对象，传入返回消息和目的地址（IP和端口）
            ctx.writeAndFlush(new DatagramPacket(Unpooled.copiedBuffer(
                    "谚语查询结果：测试test",CharsetUtil.UTF_8), packet.sender()));
        }
    }

    @Override
    public void exceptionCaught(ChannelHandlerContext ctx,Throwable cause)
            throws Exception{
        ctx.close();
        cause.printStackTrace();
    }

    @Override
    protected void channelRead0(ChannelHandlerContext ctx, DatagramPacket msg) throws Exception {
        messageReceived(ctx,msg);
    }
}
