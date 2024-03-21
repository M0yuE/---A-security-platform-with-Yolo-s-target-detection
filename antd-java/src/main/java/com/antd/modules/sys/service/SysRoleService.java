package com.antd.modules.sys.service;


import com.baomidou.mybatisplus.extension.service.IService;
import com.antd.modules.sys.entity.SysRoleEntity;
import com.antd.common.utils.PageUtils;

import java.util.Map;
public interface SysRoleService extends IService<SysRoleEntity> {

	PageUtils queryPage(Map<String, Object> params);

	void saveRole(SysRoleEntity role);

	void update(SysRoleEntity role);
	
	void deleteBatch(Long[] roleIds);

}
