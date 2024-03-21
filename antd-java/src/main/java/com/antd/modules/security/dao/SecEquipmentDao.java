package com.antd.modules.security.dao;


import com.antd.modules.security.entity.SecEquipment;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface SecEquipmentDao extends BaseMapper<SecEquipment> {
    IPage<SecEquipment> queryListPage(IPage<SecEquipment> iPage, @Param("params") Map<String, Object> params);
    List<Integer> queryIdByPid(List<Integer> pids);

    List<SecEquipment> queryAll();
}
