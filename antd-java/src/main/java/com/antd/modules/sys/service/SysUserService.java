package com.antd.modules.sys.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.antd.modules.sys.entity.SysUserEntity;
import com.antd.common.utils.PageUtils;

import java.util.List;
import java.util.Map;

public interface SysUserService extends IService<SysUserEntity> {

	List<String> queryAllPerms(Long userId);

	PageUtils queryPage(Map<String, Object> params);
	
	/**
	 * 查询用户的所有菜单ID
	 */
	List<Long> queryAllMenuId(Long userId);
	
	/**
	 * 保存用户
	 */
	void saveUser(SysUserEntity user);
	
	/**
	 * 修改用户
	 */
	void update(SysUserEntity user);

	/**
	 * 修改密码
	 * @param userId       用户ID
	 * @param password     原密码
	 * @param newPassword  新密码
	 */
	boolean updatePassword(Long userId, String password, String newPassword);

	List<SysUserEntity> getManagerUserByStoreId(Long storeId);
}
