package com.antd.modules.security.dao;


import com.antd.modules.security.entity.SecConnectModular;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface SecConnectModularDao extends BaseMapper<SecConnectModular> {
    IPage<SecConnectModular> queryListPage(IPage<SecConnectModular> iPage, @Param("params") Map<String, Object> params);

    List<SecConnectModular> queryAll();
}
