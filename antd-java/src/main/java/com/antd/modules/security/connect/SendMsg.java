package com.antd.modules.security.connect;

import com.antd.common.utils.SpringContextUtils;
import com.antd.modules.security.entity.SecConnectModular;
import com.antd.modules.security.entity.SecInstruct;
import io.netty.buffer.ByteBuf;
import io.netty.buffer.Unpooled;
import io.netty.channel.ChannelHandlerContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;

import java.util.List;

public class SendMsg implements Runnable {

    private Logger logger = LoggerFactory.getLogger(getClass());
    private ChannelHandlerContext ctx;
    private String prefix;
    private boolean isPushThread = true;
    private InstructQueue queue = null;
    public SendMsg(ChannelHandlerContext ctx, String prefix) {
        ChannelAttr channelAttr = ctx.channel().attr(NettyConstant.CTX_INFO).get();
        InstructQueue instructQueue = new InstructQueue();
        queue = instructQueue;
        channelAttr.setInstructQueue(instructQueue);
        this.ctx = ctx;
        this.prefix = prefix;
    }
    public SendMsg(ChannelHandlerContext ctx, String prefix,String flag) {
        ChannelAttr channelAttr = ctx.channel().attr(NettyConstant.CTX_INFO).get();
        queue = channelAttr.getInstructQueue();
        this.ctx = ctx;
        this.prefix = prefix;
    }

    @Override
    public void run() {
        RedisTemplate<String, Object> redisTemplate = (RedisTemplate<String, Object>) SpringContextUtils.getBean("redisTemplate");
        ChannelAttr channelAttr = ctx.channel().attr(NettyConstant.CTX_INFO).get();
        SecConnectModular modular = channelAttr.getSecConnectModular();
        if (isPushThread) {//开启发送线程
            SendMsg sendMsg = new SendMsg(ctx, prefix,null);
            sendMsg.isPushThread = false;
            ThreadPoolTaskExecutor exe = (ThreadPoolTaskExecutor) SpringContextUtils.getBean("asyncServiceExecutor");
            exe.submit(sendMsg);
            boolean flag = true;
            while (flag) {
                if (ctx.channel().isActive()) {
                    try {
                        Thread.sleep(500);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                    if(queue.size() >= 3){
                        try {
                            Thread.sleep(3000);
                            continue;
                        } catch (InterruptedException e) {
                            e.printStackTrace();
                        }
                    }
                    SecConnectModular cacheModular = (SecConnectModular) redisTemplate.opsForValue().get("modularInfo:"+modular.getConnectId()+ ":" + modular.getId());
                    List<SecInstruct> instructList = cacheModular.getInstructList();
                    for (SecInstruct instruct : instructList) {
                        try {
                            Thread.sleep(300);
                        } catch (InterruptedException e) {
                            e.printStackTrace();
                        }
                        queue.pushInstruct(instruct.getInstruct());
                    }
                    int intervalDelay = 3000;
                    if(!cacheModular.getQueryInterval().equals(0)){
                        intervalDelay = cacheModular.getQueryInterval();
                    }
                    try {
                        Thread.sleep(intervalDelay);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                } else {
                    flag = false;
                    logger.info("连接已断开，服务器端发送线程结束！！");
                }
            }
            logger.info("指令push线程结束："+modular.getName()+"的push线程结束了");
        } else{//发送线程执行
            boolean flag = true;
            while(flag){
                if(ctx.channel().isActive()){
                    SecConnectModular cacheModular = (SecConnectModular) redisTemplate.opsForValue().get("modularInfo:" +modular.getConnectId()+ ":" +modular.getId());
                    while(!queue.isEmpty()){
                        String ins = queue.getInstructFromQueue();
                        String conStr = prefix+"发送线程执行发送指令："+ins;
                        logger.info(conStr);
                        try {
                            byte[] bytes = BinaryConversionUtils.hexStrToBinaryStr(ins);
                            ByteBuf byteBuf = Unpooled.copiedBuffer(bytes);
                            ctx.writeAndFlush(byteBuf);
                            int interval = 500;
                            if(!cacheModular.getInstructInterval().equals(0)){
                                interval = cacheModular.getInstructInterval();
                            }
                            Thread.sleep(interval);
                        } catch (Exception e) {
                            logger.error(e.getMessage());
                        }
                    }
                }else{
                    flag = false;
                }
                try {
                    Thread.sleep(1500);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
            logger.info("发送线程结束："+modular.getName()+"的发送线程结束了");
        }
    }
}
