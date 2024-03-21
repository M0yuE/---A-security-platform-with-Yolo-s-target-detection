package com.antd.modules.security.connect;

import com.antd.modules.security.dao.SecConnectModularDao;
import com.antd.modules.security.dao.SecDataDao;
import com.antd.modules.security.dao.SecInstructDao;
import com.antd.modules.security.entity.SecConnectModular;
import com.antd.modules.security.entity.SecData;
import com.antd.modules.security.entity.SecInstruct;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.concurrent.TimeUnit;

@Component
public class CacheUpdateUtils {
    private Logger logger = LoggerFactory.getLogger(getClass());
    @Resource
    private SecConnectModularDao secConnectModularDao;
    @Resource
    private RedisTemplate<String,Object> redisTemplate;
    @Resource
    private SecInstructDao secInstructDao;
    @Resource
    private SecDataDao secDataDao;
    @PostConstruct
    public void updateCache(){
        Set<String> keys = redisTemplate.keys("modular*");
        redisTemplate.delete(keys);
        List<SecConnectModular> secConnectModulars = secConnectModularDao.selectList(new QueryWrapper<>());
        List<SecInstruct> secInstructs = secInstructDao.queryListWithPid();
        for(SecConnectModular sec : secConnectModulars){
            if(sec.getVerify() != null){
                redisTemplate.opsForValue().set("modular:"+sec.getConnectId()+":"+sec.getVerify(),sec);
            }
            List<SecInstruct> instructs = getListByModularId(secInstructs, sec.getId());
            sec.setInstructList(instructs);
            redisTemplate.opsForValue().set("modularInfo:"+sec.getConnectId()+":"+sec.getId(),sec);
        }
        List<SecData> secDatas = secDataDao.queryDataWithPInfo();
        for(SecInstruct instruct : secInstructs){
            String insStr = instruct.getInstruct();
            String cmdId = insStr.substring(0,4);
            String key = "modularInstruct:"+instruct.getConnectId()+":"+instruct.getModularId() + ":" + cmdId;
            List<SecData> dataListByInstructId = getDataListByInstructId(secDatas, instruct.getId());
            redisTemplate.opsForValue().set(key,dataListByInstructId);
        }
        updateData();
    }
    private void updateData(){//直接热更新缓存
        Set<String> keys = redisTemplate.keys("instructData*");
        List<Object> secDatas = redisTemplate.opsForValue().multiGet(keys);
        List<SecData> secData = secDataDao.queryDataWithPInfo();
        for(SecData data : secData){
            for(Object cacheData : secDatas){
                SecData cD = (SecData) cacheData;
                if(data.getId().equals(cD.getId())){
                    data.setFetchTime(cD.getFetchTime());
                    data.setCurData(cD.getCurData());
                    String key = "instructData:" + data.getId();
                    Long expire = redisTemplate.getExpire(key, TimeUnit.MILLISECONDS);
                    if(expire != -1){
                        redisTemplate.opsForValue().set(key,data,expire,TimeUnit.MILLISECONDS);
                    }else{
                        redisTemplate.opsForValue().set(key,data);
                    }
                    keys.remove(key);
                    break;
                }
            }
        }
        redisTemplate.delete(keys);
    }
    private List<SecData> getDataListByInstructId(List<SecData> secDatas,Integer instructId){
        List<SecData> retList = new ArrayList<>();
        for(SecData secData : secDatas){
            if(secData.getInstructId().equals(instructId)){
                retList.add(secData);
            }
        }
        return retList;
    }
    @Async("asyncServiceExecutor")
    public void updateCacheRuntime(){
        Set<String> keys = redisTemplate.keys("modular*");
        List<SecConnectModular> secConnectModulars = secConnectModularDao.selectList(new QueryWrapper<>());
        List<SecInstruct> secInstructs = secInstructDao.queryListWithPid();
        for(SecConnectModular sec : secConnectModulars){
            String key = null;
            if(sec.getVerify() != null){
                key = "modular:"+sec.getConnectId()+":"+sec.getVerify();
                redisTemplate.opsForValue().set(key,sec);
                keys.remove(key);
            }
            List<SecInstruct> instructs = getListByModularId(secInstructs, sec.getId());
            sec.setInstructList(instructs);
            key = "modular:"+sec.getId();
            redisTemplate.opsForValue().set("modularInfo:"+sec.getConnectId()+":"+sec.getId(),sec);
            keys.remove(key);
        }
        List<SecData> secDatas = secDataDao.queryDataWithPInfo();
        for(SecInstruct instruct : secInstructs){
            String insStr = instruct.getInstruct();
            String cmdId = insStr.substring(0,4);
            String key = "modularInstruct:"+instruct.getConnectId()+":"+instruct.getModularId() + ":" + cmdId;
            List<SecData> dataListByInstructId = getDataListByInstructId(secDatas, instruct.getId());
            redisTemplate.opsForValue().set(key,dataListByInstructId);
            keys.remove(key);
        }
        redisTemplate.delete(keys);
        updateData();
        logger.info("热更新缓存数据完成！");
    }
    private List<SecInstruct> getListByModularId(List<SecInstruct> secInstructs,Integer modularId){
        List<SecInstruct> retList = new ArrayList<>();
        for(SecInstruct instruct : secInstructs){
            if(instruct.getModularId().equals(modularId)){
                retList.add(instruct);
            }
        }
        return retList;
    }
}
