package com.antd.modules.sys.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.antd.common.utils.R;
import com.antd.modules.sys.dao.SysMenuDao;
import com.antd.modules.sys.entity.SysMenuEntity;
import com.antd.modules.sys.entity.SysRoleMenuEntity;
import com.antd.common.utils.Constant;
import com.antd.modules.sys.service.SysMenuService;
import com.antd.modules.sys.service.SysRoleMenuService;
import com.antd.modules.sys.service.SysUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;


@Service("sysMenuService")
public class SysMenuServiceImpl extends ServiceImpl<SysMenuDao, SysMenuEntity> implements SysMenuService {
	@Autowired
	private SysUserService sysUserService;
	@Autowired
	private SysRoleMenuService sysRoleMenuService;
	
	@Override
	public List<SysMenuEntity> queryListParentId(Long parentId, List<Long> menuIdList) {
		List<SysMenuEntity> menuList = queryListParentId(parentId);
		if(menuIdList == null){
			return menuList;
		}
		
		List<SysMenuEntity> userMenuList = new ArrayList<>();
		for(SysMenuEntity menu : menuList){
			if(menuIdList.contains(menu.getMenuId())){
				userMenuList.add(menu);
			}
		}
		return userMenuList;
	}

	@Override
	public List<SysMenuEntity> queryListParentId(Long parentId) {
		return baseMapper.queryListParentId(parentId);
	}

	@Override
	public List<SysMenuEntity> queryNotButtonList() {
		return baseMapper.queryNotButtonList();
	}

	@Override
	public void delete(Long menuId){
		//删除菜单
		this.removeById(menuId);
		//删除菜单与角色关联
		sysRoleMenuService.remove(new QueryWrapper<SysRoleMenuEntity>().eq("menu_id", menuId));
	}

	@Override
	public List<SysMenuEntity> queryTreeList() {
		List<SysMenuEntity> menuList = queryListHasParentName();
		List<SysMenuEntity> treeList = new LinkedList<>();
		for(SysMenuEntity menu : menuList){
			if(menu.getParentId() == 0){
				List<SysMenuEntity> childrenList = getChildrenList(menu.getMenuId(), menuList);
				if(childrenList.size() > 0){
					menu.setChildren(childrenList);
				}
				treeList.add(menu);
			}
		}
		return treeList;
	}
	private List<SysMenuEntity> getChildrenList(Long pid,List<SysMenuEntity> list){
		List<SysMenuEntity> retList = new LinkedList<>();
		for(SysMenuEntity menu : list){
			if(menu.getParentId().equals(pid)){
				List<SysMenuEntity> childrenList = getChildrenList(menu.getMenuId(), list);
				if(childrenList.size() > 0){
					menu.setChildren(childrenList);
				}
				retList.add(menu);
			}
		}
		return retList;
	}
	public List<SysMenuEntity> queryListHasParentName(){
		return baseMapper.queryListHasParentName();
	}

}
