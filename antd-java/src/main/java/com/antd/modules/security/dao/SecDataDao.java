package com.antd.modules.security.dao;


import com.antd.modules.security.entity.SecData;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface SecDataDao extends BaseMapper<SecData> {
    IPage<SecData> queryListPage(IPage<SecData> iPage, @Param("params") Map<String, Object> params);
    List<Integer> queryIdByPid(List<Integer>  pids);
    List<SecData> queryDataWithPInfo();
    IPage<SecData> queryPageWithMoreInfo(IPage<SecData> iPage, @Param("params") Map<String, Object> params);
    List<SecData> getQueryDataByEquipment(@Param("id") Integer id);
    SecData queryDataWithPInfoById(@Param("id") Integer id);

    //查询所有数据项中状态指令（即，绑定数据为null）的数据
    List<SecData> queryAllStateData();

    //查询所有数据项中控制指令（即，绑定数据不为空）的数据
    List<SecData> queryAllControllerData();
}
