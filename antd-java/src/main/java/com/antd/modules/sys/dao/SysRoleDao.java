package com.antd.modules.sys.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.antd.modules.sys.entity.SysRoleEntity;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
@Mapper
public interface SysRoleDao extends BaseMapper<SysRoleEntity> {
	List<Long> getRoleListByUserId(Object userId);

}
