package com.antd.modules.security.dao;


import com.antd.modules.security.entity.SecWarnMsg;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface SecWarnMsgDao extends BaseMapper<SecWarnMsg> {
    IPage<SecWarnMsg> queryListPage(IPage<SecWarnMsg> iPage, @Param("params") Map<String, Object> params);

    List<SecWarnMsg> uniQueryList();
}
