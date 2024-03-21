package com.antd.modules.sys.controller;

import com.antd.common.annotation.SysLog;
import com.antd.modules.sys.entity.SysRoleEntity;
import com.antd.modules.sys.service.SysRoleMenuService;
import com.antd.modules.sys.service.SysRoleService;
import com.antd.common.utils.PageUtils;
import com.antd.common.utils.R;
import com.antd.common.validator.ValidatorUtils;
import com.antd.modules.sys.service.UserPermsService;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
@RestController
@RequestMapping("/sys/role")
public class SysRoleController extends AbstractController {
	@Autowired
	private SysRoleService sysRoleService;
	@Autowired
	private SysRoleMenuService sysRoleMenuService;
	@Autowired
	private UserPermsService userPermsService;

	/**
	 * 角色列表
	 */
	@RequestMapping("/list")
	@RequiresPermissions("sys.role.list")
	public R list(@RequestParam Map<String, Object> params){
		PageUtils page = sysRoleService.queryPage(params);

		return R.ok().put("page", page);
	}
	
	/**
	 * 角色列表
	 */
	@RequestMapping("/select")
	public R select(String shopRole){
		List<SysRoleEntity> list = sysRoleService.list(new QueryWrapper<SysRoleEntity>().eq(shopRole != null,"shop_role",shopRole));
		return R.ok().put("list", list);
	}
	
	/**
	 * 角色信息
	 */
	@RequestMapping("/info/{roleId}")
	@RequiresPermissions("sys.role.info")
	public R info(@PathVariable("roleId") Long roleId){
		SysRoleEntity role = sysRoleService.getById(roleId);
		
		//查询角色对应的菜单
		List<Long> menuIdList = sysRoleMenuService.queryMenuIdList(roleId);
		role.setMenuIdList(menuIdList);

		return R.ok().put("role", role);
	}
	
	/**
	 * 保存角色
	 */
	@SysLog("保存或修改角色")
	@RequestMapping("/saveOrUpdate")
	@RequiresPermissions("sys.role.save")
	public R save(@RequestBody SysRoleEntity role){
		ValidatorUtils.validateEntity(role);
		if(role.getRoleId() != null){
			sysRoleService.update(role);
		}else{
			sysRoleService.saveRole(role);
		}
		userPermsService.updateAllCacheUser();
		return R.ok().put("result",role);
	}

	/**
	 * 删除角色
	 */
	@SysLog("删除角色")
	@RequestMapping("/delete")
	@RequiresPermissions("sys.role.delete")
	public R delete(@RequestBody Long[] roleIds){
		sysRoleService.deleteBatch(roleIds);
		userPermsService.updateAllCacheUser();
		return R.ok();
	}
}
