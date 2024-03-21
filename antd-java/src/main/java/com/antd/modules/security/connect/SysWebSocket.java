package com.antd.modules.security.connect;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import javax.websocket.*;
import javax.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.concurrent.CopyOnWriteArraySet;

@ServerEndpoint("/socket/sysWebsocket")
@Component
public class SysWebSocket {
    private Logger logger = LoggerFactory.getLogger(getClass());
    // concurrent包的线程安全Set，用来存放每个客户端对应的MyWebSocket对象。
    public static CopyOnWriteArraySet<SysWebSocket> webSocketSet = new CopyOnWriteArraySet<SysWebSocket>();

    // 与某个客户端的连接会话，需要通过它来给客户端发送数据
    private Session session;


    public Session getSession() {
        return session;
    }


    public void setSession(Session session) {
        this.session = session;
    }
    @OnOpen
    public void onOpen(Session session) throws Exception {
        this.session = session;
        webSocketSet.add(this);
    }
    @OnClose
    public void onClose() {
        webSocketSet.remove(this);
    }
    @OnMessage
    public void onMessage(String message, Session session) {
        logger.info("SysWebSocket 来自客户端的消息:" + message);
    }
    @OnError
    public void onError(Session session, Throwable error) {
        logger.error("SysWebSocket发生错误");
        webSocketSet.remove(this);
    }

    public void sendMessage(String message) throws IOException {
        synchronized (session){
            try {
                session.getBasicRemote().sendText(message);
            } catch (IllegalStateException e) {
                logger.error("websocket调用异常："+e.getMessage());
            }
        }
    }
    public static void sendInfo(String message) {
        for (SysWebSocket item : webSocketSet) {
            try {
                item.sendMessage(message);
            } catch (IOException e) {
                e.printStackTrace();
                continue;
            }
        }
    }
}
