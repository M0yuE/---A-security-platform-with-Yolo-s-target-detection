package com.antd.common.utils;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.FileSystemResource;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;
import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import java.io.File;
import java.util.Map;

@Component
public class EmailUtils {
    @Autowired
    private JavaMailSender javaMailSender;
    @Value("${spring.mail.username}")
    private String senderMailAddress;
    @Autowired
    private TemplateEngine templateEngine;
    public String getEmailCode() {
    	String[] c = new String[35];
		for(int i = 65;i < 91;i++){
			c[i - 65] = (char)i+"";
		}
		for(int i = 1;i < 10;i++){
			c[i+25] = i+"";
		}
		String str = "";
		for(int i = 0;i < 6;i++){
			str += c[(int)(Math.random()*35)];
		}
		return str;
	}
    @Async("asyncServiceExecutor")
    public void sendSimpleMail(Map<String, Object> valueMap){
        MimeMessage mimeMessage = null;
        try {
            mimeMessage = javaMailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true);
            // 设置发件人邮箱
            helper.setFrom(senderMailAddress);
            // 设置收件人邮箱
            helper.setTo(valueMap.get("email").toString());
            // 设置邮件标题
            helper.setSubject(valueMap.get("title").toString());
            // 添加正文（使用thymeleaf模板）
            Context context = new Context();
            context.setVariables(valueMap);
            String content = this.templateEngine.process("mail", context);
            helper.setText(content, true);
            // 添加附件
            if (valueMap.get("filePathList") != null) {
                String[] filePathList = (String[]) valueMap.get("filePathList");
                for(String filePath: filePathList) {
                    FileSystemResource fileSystemResource = new FileSystemResource(new File(filePath));
                    String fileName = filePath.substring(filePath.lastIndexOf(File.separator));
                    helper.addAttachment(fileName, fileSystemResource);
                }
            }
            // 发送邮件
            javaMailSender.send(mimeMessage);
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }
}

