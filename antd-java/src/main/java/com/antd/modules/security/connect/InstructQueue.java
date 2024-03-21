package com.antd.modules.security.connect;

import java.util.concurrent.ConcurrentLinkedDeque;

public class InstructQueue {
    private ConcurrentLinkedDeque<String> instructQueue = new ConcurrentLinkedDeque<>();
    public void pushInstruct(String instruct){
        instructQueue.offer(instruct);
    }
    public void pushInstructFirst(String instruct){
        instructQueue.offerFirst(instruct);
    }
    public String getInstructFromQueue(){
        return instructQueue.poll();
    }
    public boolean isEmpty(){
        return instructQueue.isEmpty();
    }
    public int size(){
        return instructQueue.size();
    }
}
