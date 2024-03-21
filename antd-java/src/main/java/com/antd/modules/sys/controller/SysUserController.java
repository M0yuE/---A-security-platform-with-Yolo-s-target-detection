package com.antd.modules.sys.controller;


import com.antd.modules.sys.service.UserPermsService;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.antd.common.annotation.SysLog;
import com.antd.common.utils.Constant;
import com.antd.common.utils.PageUtils;
import com.antd.common.utils.R;
import com.antd.common.validator.Assert;
import com.antd.common.validator.ValidatorUtils;
import com.antd.common.validator.group.AddGroup;
import com.antd.common.validator.group.UpdateGroup;
import com.antd.modules.sys.entity.SysMenuEntity;
import com.antd.modules.sys.entity.SysUserEntity;
import com.antd.modules.sys.service.SysMenuService;
import com.antd.modules.sys.service.SysUserRoleService;
import com.antd.modules.sys.service.SysUserService;
import com.antd.modules.sys.shiro.ShiroUtils;
import org.apache.commons.lang.ArrayUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
@RestController
@RequestMapping("/sys/user")
public class SysUserController extends AbstractController {
	@Autowired
	private SysUserService sysUserService;
	@Autowired
	private SysUserRoleService sysUserRoleService;
	@Autowired
	private SysMenuService sysMenuService;
	@Autowired
	private UserPermsService userPermsService;
	/**
	 * 所有用户列表
	 */
	@RequestMapping("/list")
	@RequiresPermissions("sys.user.list")
	public R list(@RequestParam Map<String, Object> params){
		PageUtils page = sysUserService.queryPage(params);

		return R.ok().put("page", page);
	}
	
	/**
	 * 获取登录的用户信息
	 */
	@RequestMapping("/info")
	public R info(){
		//获取权限
		SysUserEntity user = getUser();
		List<String> permissList = new ArrayList<>();
		List<String> eachList = new ArrayList<>();
		if(user.getUserId().intValue() == Constant.SUPER_ADMIN){//获取最高权限
			List<SysMenuEntity> list = sysMenuService.list();
			for (SysMenuEntity menu : list){
				eachList.add(menu.getPerms());
			}
		}else{//查询权限
			eachList = sysUserService.queryAllPerms(user.getUserId());
		}
		for(String perms : eachList){
			if(perms != null && perms.contains(",")){
				String[] split = perms.split(",");
				for (String str: split) {
					if(permissList.indexOf(str) == -1){
						permissList.add(str);
					}
				}
			}else{
				if(permissList.indexOf(perms) == -1){
					permissList.add(perms);
				}
			}
		}
		return R.ok().put("user", user).put("perms",permissList);
	}
	
	/**
	 * 修改登录用户密码
	 */
	@SysLog("修改密码")
	@RequestMapping("/password")
	public R password(String password, String newPassword){
		Assert.isBlank(newPassword, "新密码不为能空");

		//原密码
		password = ShiroUtils.sha256(password, getUser().getSalt());
		//新密码
		newPassword = ShiroUtils.sha256(newPassword, getUser().getSalt());
				
		//更新密码
		boolean flag = sysUserService.updatePassword(getUserId(), password, newPassword);
		if(!flag){
			return R.error("原密码不正确");
		}
		
		return R.ok();
	}
	
	/**
	 * 用户信息
	 */
	@RequestMapping("/info/{userId}")
	@RequiresPermissions("sys.user.info")
	public R info(@PathVariable("userId") Long userId){
		SysUserEntity user = sysUserService.getById(userId);
		
		//获取用户所属的角色列表
		List<Long> roleIdList = sysUserRoleService.queryRoleIdList(userId);
		user.setRoleIdList(roleIdList);
		
		return R.ok().put("user", user);
	}
	
	/**
	 * 保存用户
	 */
	@SysLog("保存或修改用户")
	@RequestMapping("/saveOrUpdate")
	@RequiresPermissions("sys.user.save")
	public R save(@RequestBody SysUserEntity user){
		ValidatorUtils.validateEntity(user, AddGroup.class);
		if(user.getUserId() != null){
			sysUserService.update(user);
			userPermsService.updateByUserName(user.getUsername());
		}else{
			sysUserService.saveUser(user);
		}
		return R.ok().put("result",user);
	}
	/**
	 * 判断用户名是否可用
	 */
	@RequestMapping("/isNotExists")
	public R isNotExists(String username){
		SysUserEntity user = sysUserService.getOne(new QueryWrapper<SysUserEntity>().eq("username", username));
		return R.ok().put("result",user == null).put("record",user);
	}

	/**
	 * 删除用户
	 */
	@SysLog("删除用户")
	@RequestMapping("/delete")
	@RequiresPermissions("sys.user.delete")
	public R delete(@RequestBody Long[] userIds){
		if(ArrayUtils.contains(userIds, 1L)){
			return R.error("系统管理员不能删除");
		}
		
		if(ArrayUtils.contains(userIds, getUserId())){
			return R.error("当前用户不能删除");
		}

		sysUserService.removeByIds(Arrays.asList(userIds));
		//删除相关的中间表
		sysUserRoleService.deleteUserRoleByUserIds(userIds);
		userPermsService.deleteCacheUserByIdList(userIds);
		return R.ok();
	}
}
