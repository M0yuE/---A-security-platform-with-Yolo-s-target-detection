package com.antd.modules.security.service;

import com.antd.common.utils.PageUtils;
import com.antd.common.utils.Query;
import com.antd.common.utils.R;
import com.antd.modules.security.connect.*;
import com.antd.modules.security.dao.SecConnectModularDao;
import com.antd.modules.security.dao.SecDataDao;
import com.antd.modules.security.dao.SecEquipmentDao;
import com.antd.modules.security.dao.SecInstructDao;
import com.antd.modules.security.entity.*;
import com.antd.modules.security.entity.uniapp.Datas;
import com.antd.modules.security.entity.uniapp.Equipments;
import com.antd.modules.security.entity.uniapp.UniRealDatas;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import io.netty.channel.Channel;
import io.netty.channel.ChannelHandlerContext;
import org.springframework.beans.BeanUtils;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.*;

@Service
public class SecEquipmentService extends ServiceImpl<SecEquipmentDao, SecEquipment> {
  @Resource
  private SecConnectModularDao secConnectModularDao;
  @Resource
  private SecEquipmentDao secEquipmentDao;
  @Resource
  private SecInstructDao secInstructDao;
  @Resource
  private SecDataDao secDataDao;
  @Resource
  private CacheUpdateUtils cacheUpdateUtils;
  @Resource
  private HandlerDataService handlerDataService;

  @Resource
  private RedisTemplate<String, Object> redisTemplate;

  public R sendInstruct(Integer id) {
    SecInstruct instruct = secInstructDao.queryInstructWithPid(id);
    List<Channel> serverList = NettyConstant.SERVER_LIST;
    for (Channel channel : serverList) {
      ChannelAttr attr = channel.attr(NettyConstant.CTX_INFO).get();
      if (attr != null) {
        SecConnect secConnect = attr.getSecConnect();
        if (instruct.getConnectId().equals(secConnect.getId())) {
          List<ChannelHandlerContext> childrenCtxs = attr.getChildrenCtxs();
          for (ChannelHandlerContext ctx : childrenCtxs) {
            ChannelAttr channelAttr = ctx.channel().attr(NettyConstant.CTX_INFO).get();
            if (channelAttr != null) {
              SecConnectModular secConnectModular = channelAttr.getSecConnectModular();
              if (secConnectModular.getId().equals(instruct.getModularId())) {
                InstructQueue queue = channelAttr.getInstructQueue();
                queue.pushInstructFirst(instruct.getInstruct());
                return R.ok().put("msg", "指令进入发送队列！");
              }
            }
          }
        }
      }
    }
    return R.error("设备未连接云平台！");
  }

  //uniapp端指令下发，需要传入数据项对应的id
  public R uniSendInstruct(Integer id) {
    SecData secData = secDataDao.queryDataWithPInfoById(id);    //传来的是数据项的id，而需要的是instruct_id
    SecInstruct instruct = secInstructDao.queryInstructWithPid(secData.getInstructId());
    List<Channel> serverList = NettyConstant.SERVER_LIST;
    for (Channel channel : serverList) {
      ChannelAttr attr = channel.attr(NettyConstant.CTX_INFO).get();
      if (attr != null) {
        SecConnect secConnect = attr.getSecConnect();
        if (instruct.getConnectId().equals(secConnect.getId())) {
          List<ChannelHandlerContext> childrenCtxs = attr.getChildrenCtxs();
          for (ChannelHandlerContext ctx : childrenCtxs) {
            ChannelAttr channelAttr = ctx.channel().attr(NettyConstant.CTX_INFO).get();
            if (channelAttr != null) {
              SecConnectModular secConnectModular = channelAttr.getSecConnectModular();
              if (secConnectModular.getId().equals(instruct.getModularId())) {
                InstructQueue queue = channelAttr.getInstructQueue();
                queue.pushInstructFirst(instruct.getInstruct());
                List<UniRealDatas> uniRealDatasList = getUniRealDatasList();
                return R.ok().put("Modular", uniRealDatasList);
              }
            }
          }
        }
      }
    }
    return R.error("设备未连接云平台！");
  }

  public R getUniAppControllerData() {
    List<UniRealDatas> uniRealDatasList = getUniRealDatasList();
    return R.ok().put("Modular", uniRealDatasList);
  }

  //<editor-fold desc="控制数据加载">
  private List<UniRealDatas> getUniRealDatasList() {
    List<SecData> secData = secDataDao.queryAllControllerData();
    List<SecEquipment> secEquipments = secEquipmentDao.queryAll();
    List<SecConnectModular> secConnectModulars = secConnectModularDao.queryAll();
    setRedisCurFetchData(secData);
    List<UniRealDatas> uniRealDatasList = setUniRealDatasList(secConnectModulars, secEquipments, secData);
    return uniRealDatasList;
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
  //</editor-fold>


  public List<SecData> getDataListByInstructId(Integer id) {
    SecInstruct instruct = secInstructDao.selectById(id);
    if (instruct.getType().equals(1)) {
      List<SecData> datas = secDataDao.getQueryDataByEquipment(instruct.getEquipmentId());
      return datas;
    }
    return null;
  }

  public R parseData(SecData secData) {
    String result = handlerDataService.computeData(secData);
    return R.ok().put("result", result);
  }

  public PageUtils queryModularPage(Map<String, Object> params) {
    IPage<SecConnectModular> iPage = secConnectModularDao.queryListPage(new Query<SecConnectModular>().getPage(params), params);
    return new PageUtils(iPage);
  }

  public void modularSaveOrUpdate(SecConnectModular modular) {
    if (modular.getId() != null) {
      secConnectModularDao.updateById(modular);
    } else {
      secConnectModularDao.insert(modular);
    }
    cacheUpdateUtils.updateCacheRuntime();
  }

  @Transactional
  public void modularDelete(List<Integer> ids) {
    List<Integer> equipmentIds = secEquipmentDao.queryIdByPid(ids);
    if (equipmentIds != null && equipmentIds.size() > 0) {
      equipmentDelete(equipmentIds);
    }
    secConnectModularDao.deleteBatchIds(ids);
  }

  public PageUtils queryEquipmentPage(Map<String, Object> params) {
    IPage<SecEquipment> iPage = secEquipmentDao.queryListPage(new Query<SecEquipment>().getPage(params), params);
    return new PageUtils(iPage);
  }

  public void equipmentSaveOrUpdate(SecEquipment modular) {
    if (modular.getId() != null) {
      secEquipmentDao.updateById(modular);
    } else {
      secEquipmentDao.insert(modular);
    }
    cacheUpdateUtils.updateCacheRuntime();
  }

  public void equipmentDelete(List<Integer> ids) {
    List<Integer> integers = secInstructDao.queryIdByPid(ids);
    if (integers != null && integers.size() > 0) {
      instructDelete(integers);
    }
    secEquipmentDao.deleteBatchIds(ids);
  }

  public PageUtils queryInstructPage(Map<String, Object> params) {
    IPage<SecInstruct> iPage = secInstructDao.queryListPage(new Query<SecInstruct>().getPage(params), params);
    return new PageUtils(iPage);
  }

  public void instructSaveOrUpdate(SecInstruct modular) {
    if (modular.getId() != null) {
      secInstructDao.updateById(modular);
    } else {
      secInstructDao.insert(modular);
    }
    cacheUpdateUtils.updateCacheRuntime();
  }

  public void instructDelete(List<Integer> ids) {
    List<Integer> integers = secDataDao.queryIdByPid(ids);
    if (integers != null && integers.size() > 0) {
      dataDelete(integers);
    }
    secInstructDao.deleteBatchIds(ids);
  }

  public PageUtils queryDataPage(Map<String, Object> params) {
    IPage<SecData> iPage = secDataDao.queryListPage(new Query<SecData>().getPage(params), params);
    return new PageUtils(iPage);
  }

  public void dataSaveOrUpdate(SecData modular) {
    if (modular.getId() != null) {
      secDataDao.updateById(modular);
    } else {
      secDataDao.insert(modular);
    }
    cacheUpdateUtils.updateCacheRuntime();
  }

  public void dataDelete(List<Integer> ids) {
    secDataDao.deleteBatchIds(ids);
    cacheUpdateUtils.updateCacheRuntime();
  }
}
