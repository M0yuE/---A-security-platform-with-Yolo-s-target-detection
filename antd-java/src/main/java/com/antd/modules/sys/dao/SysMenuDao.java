package com.antd.modules.sys.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.antd.modules.sys.entity.SysMenuEntity;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
@Mapper
public interface SysMenuDao extends BaseMapper<SysMenuEntity> {
	
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
	 * 查询含有父级名称的list
	 * @return
	 */
	List<SysMenuEntity> queryListHasParentName();
	List<String> queryPermsByUserId(Object userId);
}
