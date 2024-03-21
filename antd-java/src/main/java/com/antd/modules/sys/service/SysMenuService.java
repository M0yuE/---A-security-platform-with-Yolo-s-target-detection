package com.antd.modules.sys.service;


import com.baomidou.mybatisplus.extension.service.IService;
import com.antd.modules.sys.entity.SysMenuEntity;

import java.util.List;
public interface SysMenuService extends IService<SysMenuEntity> {

	/**
	 * 根据父菜单，查询子菜单
	 * @param parentId 父菜单ID
	 * @param menuIdList  用户菜单ID
	 */
	List<SysMenuEntity> queryListParentId(Long parentId, List<Long> menuIdList);

	/**
	 * 根据父菜单，查询子菜单
	 * @param parentId 父菜单ID
	 */
	List<SysMenuEntity> queryListParentId(Long parentId);
	
	/**
	 * 获取不包含按钮的菜单列表
	 */
	List<SysMenuEntity> queryNotButtonList();
	
	/**
	 * 删除
	 */
	void delete(Long menuId);
	List<SysMenuEntity> queryTreeList();
}
