package com.antd.common.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.io.File;

@Component
public class ReceiverService {
	@Value("${saveFilePath}")
	private String saveFilePath;
	public void receiveMessage(String key) {
		if(key.contains(":")){
			String[] ar = key.split(":");
			if(ar.length == 2 && "file".equals(ar[0])){
				File file = new File(saveFilePath+ar[1]);
				if(file.exists()){
					file.delete();
				}
			}
		}
    }
}
