package com.antd.modules.security.dao;


import com.antd.modules.security.entity.SecInstruct;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface SecInstructDao extends BaseMapper<SecInstruct> {
    IPage<SecInstruct> queryListPage(IPage<SecInstruct> iPage, @Param("params") Map<String, Object> params);
    List<Integer> queryIdByPid(List<Integer> pids);
    List<SecInstruct> queryListWithPid();
    SecInstruct queryInstructWithPid(@Param("id") Integer id);
}
