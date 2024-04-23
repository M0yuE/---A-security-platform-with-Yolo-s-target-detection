package com.antd.modules.security.entity;

import org.springframework.context.annotation.Bean;
import org.springframework.stereotype.Component;

import java.util.concurrent.ConcurrentHashMap;

@Component
public class EchartsShowDataStorage {
    private ConcurrentHashMap<String,String> dataStorage = new ConcurrentHashMap<>();

    public String getDataStorage(String key) {
        return dataStorage.get(key);
    }

    public void setDataStorage(String key , String value) {
        dataStorage.put(key,value);
    }
}
