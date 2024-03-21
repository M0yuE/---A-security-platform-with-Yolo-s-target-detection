package com.antd.modules.security.connect;

import com.alibaba.fastjson.JSON;
import com.antd.modules.security.dao.SecDataDao;
import com.antd.modules.security.dao.SecWarnMsgDao;
import com.antd.modules.security.entity.SecData;
import com.antd.modules.security.entity.SecWarnMsg;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;

@Component
public class HandlerDataService {
    private SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    @Resource
    private RedisTemplate<String,Object> redisTemplate;
    @Resource
    private SecWarnMsgDao secWarnMsgDao;
    @Resource
    private SecDataDao secDataDao;
    public void handlerData(ResultData resultData){
        SecData secData = resultData.getSecData();
        secData.setRetExample(resultData.getData());
        String result = computeData(secData);
        secData.setCurData(result);
        sendToPageAndSaveDb(secData);
    }
    public String computeData(SecData secData){
        String data = secData.getRetExample();
        String result = data.substring(secData.getStart(),secData.getStart() + secData.getLength());
        if(secData.getHighLowConvert().equals(1)){
            int index = data.length() / 2;
            result = data.substring(index) + data.substring(0,index);
        }
        int convertTo = secData.getConvertTo();
        if(convertTo == 1){
            int te = Integer.parseInt(result,16);
            result = te + "";
        }else if(convertTo == 2){
            long in = Long.parseLong(result,16);
            double v1 = Double.longBitsToDouble(in);
            DecimalFormat df = new DecimalFormat("#0.00");
            result = df.format(v1);
        }else if(convertTo == 3){
            int in = Integer.parseInt(result,16);
            String s = Integer.toBinaryString(in);
            result = s;
            int length = secData.getLength() * 4;
            while(result.length() < length){
                result = '0' + result;
            }
        }
        int cut = secData.getCut();
        if(cut == 1){
            int start = secData.getCutStart();
            int length = secData.getCutLength();
            if(result.length() < start + length){
                while(result.length() < start + length){
                    result = result + '0';
                }
            }
            if(length != 0){
                result = result.substring(start,start + length);
            }
        }
        if(result.contains(".")){
            String[] split = result.split("\\.");
            if(split.length > 1){
                int i = Integer.parseInt(split[1]);
                if(i == 0){
                    result = split[0];
                }
            }
        }
        return result;
    }
    public void sendToPageAndSaveDb(SecData secData){
        if(secData.getBindData() != null){
            SecData bindData = secDataDao.queryDataWithPInfoById(secData.getBindData());
            bindData.setCurData(secData.getCurData());
            secData = bindData;
        }
        String fetchTime = format.format(new Date());
        secData.setFetchTime(fetchTime);
        String key = "instructData:"+secData.getId();
        Integer cacheTime = secData.getCacheTime();
        if(cacheTime.equals(0)){
            redisTemplate.opsForValue().set(key,secData);
        }else{
            redisTemplate.opsForValue().set(key,secData,cacheTime, TimeUnit.MILLISECONDS);
        }
        checkWarn(secData);
        Map<String,Object> msgMap = new HashMap<>();
        msgMap.put("type",1);
        msgMap.put("secData",secData);
        DataWebSocket.sendInfo(JSON.toJSONString(msgMap));
    }
    private void checkWarn(SecData secData){
        int dataWarn = secData.getDataWarn();
        if(dataWarn == 1){
            String curDataStr = secData.getCurData();
            double curData = Double.parseDouble(curDataStr);
            String warnValueStr = secData.getWarnValue();
            double warnValue = Double.parseDouble(warnValueStr);
            String option = "";
            int warnOption = secData.getWarnOption();
            boolean shouldWarn = false;
            if(warnOption == 1){
                option = "等于";
                if(curData == warnValue){
                    shouldWarn = true;
                }
            }else if(warnOption == 2){
                option = "大于等于";
                if(curData >= warnValue){
                    shouldWarn = true;
                }
            }else if(warnOption == 3){
                option = "小于等于";
                if(curData <= warnValue){
                    shouldWarn = true;
                }
            }
            if(shouldWarn){
                SecWarnMsg secWarnMsg = new SecWarnMsg();
                secWarnMsg.setDataId(secData.getId());
                secWarnMsg.setWarnData(secData.getCurData());
                String createTime = format.format(new Date());
                secWarnMsg.setCreateTime(createTime);
                String msg =  secData.getEquipmentName() + "设备的"+ secData.getName() + "数据值" + option + "预警值[" + secData.getWarnValue()
                        + "]当前值为[" + secData.getCurData() + "]";
                secWarnMsg.setMsg(msg);
                String warnType = secData.getWarnType();
                String[] types = warnType.split(",");
                for(String type : types){
                    if(type.equals("1")){
                        Map<String,Object> msgMap = new HashMap<>();
                        msgMap.put("type",2);
                        msgMap.put("warnMsg",secWarnMsg);
                        msgMap.put("secData",secData);
                        SysWebSocket.sendInfo(JSON.toJSONString(msgMap));
                    }else if(type.equals("2")){
                        // TODO APP推送
                    }
                }
                Calendar ins = Calendar.getInstance();
                ins.add(Calendar.HOUR_OF_DAY,-1);
                String compareCreateTime = this.format.format(ins.getTime());
                SecWarnMsg dbRecord = secWarnMsgDao.selectOne(new QueryWrapper<SecWarnMsg>().eq("data_id", secData.getId()).eq("warn_data", secData.getCurData()).gt("create_time", compareCreateTime));
                if(dbRecord == null){
                    secWarnMsgDao.insert(secWarnMsg);
                }
            }
        }
    }
}
