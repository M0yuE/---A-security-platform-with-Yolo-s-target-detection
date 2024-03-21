package com.antd.modules.security.service;

import com.antd.common.utils.PageUtils;
import com.antd.common.utils.Query;
import com.antd.common.utils.R;
import com.antd.modules.security.dao.SecConnectModularDao;
import com.antd.modules.security.dao.SecDataDao;
import com.antd.modules.security.dao.SecEquipmentDao;
import com.antd.modules.security.entity.SecConnectModular;
import com.antd.modules.security.entity.SecData;
import com.antd.modules.security.entity.SecEquipment;
import com.antd.modules.security.entity.uniapp.Datas;
import com.antd.modules.security.entity.uniapp.Equipments;
import com.antd.modules.security.entity.uniapp.UniRealDatas;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import org.springframework.beans.BeanUtils;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.*;

@Service
public class SecRealTimeDataService {
    @Resource
    private SecDataDao secDataDao;
    @Resource
    private RedisTemplate<String, Object> redisTemplate;
    @Resource
    private SecConnectModularDao secConnectModularDao;
    @Resource
    private SecEquipmentDao secEquipmentDao;

    public PageUtils queryPage(Map<String, Object> params) {
        IPage<SecData> page = secDataDao.queryPageWithMoreInfo(new Query<SecData>().getPage(params), params);
        setRedisCurFetchData(page.getRecords());
        return new PageUtils(page);
    }

    private SecData getRealTimeData(List<Object> cacheDatas, Integer id) {
        for (Object item : cacheDatas) {
            SecData temp = (SecData) item;
            if (temp.getId().equals(id)) {
                return temp;
            }
        }
        return null;
    }

    private void setRedisCurFetchData(List<SecData> dataList) {
        Set<String> keys = redisTemplate.keys("instructData*");
        List<Object> objects = redisTemplate.opsForValue().multiGet(keys);
        for (SecData secData : dataList) {
            SecData realTimeData = getRealTimeData(objects, secData.getId());
            if (realTimeData != null) {
                secData.setCurData(realTimeData.getCurData());
                secData.setFetchTime(realTimeData.getFetchTime());
            }
        }
    }


    public R modularsAndEquipments() {
        List<SecConnectModular> modularList = secConnectModularDao.selectList(new QueryWrapper<>());
        List<SecEquipment> equipments = secEquipmentDao.selectList(new QueryWrapper<>());
        return R.ok().put("modulars", modularList).put("Equipments", equipments);
    }


    public R getUniAppRealTimeData() {
        List<SecData> secData = secDataDao.queryAllStateData();
        List<SecEquipment> secEquipments = secEquipmentDao.queryAll();
        List<SecConnectModular> secConnectModulars = secConnectModularDao.queryAll();
        setRedisCurFetchData(secData);
        List<UniRealDatas> uniRealDatasList = setUniRealDatasList(secConnectModulars, secEquipments, secData);
        //List<UniRealDatas> uniRealDatasList = setUniRealDatasList(secEquipments,secData);
        //return R.ok().put("Equipment",uniRealDatasList);
        return R.ok().put("Modular", uniRealDatasList);
    }

    private List<UniRealDatas> setUniRealDatasList(List<SecConnectModular> secConnectModularList, List<SecEquipment> secEquipmentList, List<SecData> secDataList) {
        List<UniRealDatas> uniRealDatasList = new ArrayList<>();
        for (SecConnectModular secConnectModular : secConnectModularList) {
            UniRealDatas uniRealDatas = new UniRealDatas();
            BeanUtils.copyProperties(secConnectModular, uniRealDatas);
            List<Equipments> equipmentsList = new ArrayList<>();
            for (SecEquipment secEquipment : secEquipmentList) {
                if (secEquipment.getModularId().equals(secConnectModular.getId())) {
                    Equipments equipments = new Equipments();
                    BeanUtils.copyProperties(secEquipment, equipments);
                    List<Datas> datasList = new ArrayList<>();
                    for (SecData secData : secDataList) {
                        if (secData.getEquipmentId().equals(secEquipment.getId())) {
                            Datas datas = new Datas();
                            BeanUtils.copyProperties(secData, datas);
                            datasList.add(datas);
                        }
                    }
                    equipments.setDatas(datasList);
                    equipmentsList.add(equipments);
                }
            }
            uniRealDatas.setEquipments(equipmentsList);
            uniRealDatasList.add(uniRealDatas);
        }
        return uniRealDatasList;
    }
}

