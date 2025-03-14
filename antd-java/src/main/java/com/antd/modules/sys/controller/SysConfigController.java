package com.antd.modules.sys.controller;


import com.antd.common.annotation.SysLog;
import com.antd.modules.sys.entity.SysConfigEntity;
import com.antd.modules.sys.service.SysConfigService;
import com.antd.common.utils.PageUtils;
import com.antd.common.utils.R;
import com.antd.common.validator.ValidatorUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
@RestController
@RequestMapping("/sys/config")
public class SysConfigController extends AbstractController {
	@Autowired
	private SysConfigService sysConfigService;

	/**
	 * 所有配置列表
	 */
	@RequestMapping("/list")
	@RequiresPermissions("sys.config.list")
	public R list(@RequestParam Map<String, Object> params){
		PageUtils page = sysConfigService.queryPage(params);
		return R.ok().put("page", page);
	}


	/**
	 * 配置信息
	 */
	@RequestMapping("/info/{id}")
	@RequiresPermissions("sys.config.info")
	@ResponseBody
	public R info(@PathVariable("id") Long id){
		SysConfigEntity config = sysConfigService.getById(id);

		return R.ok().put("config", config);
	}

	/**
	 * 保存配置
	 */
	@SysLog("保存配置")
	@RequestMapping("/saveOrUpdate")
	@RequiresPermissions("sys.config.save")
	public R save(@RequestBody SysConfigEntity config){
		ValidatorUtils.validateEntity(config);
		if(null==config.getId()){
			sysConfigService.saveConfig(config);
		}else{
			sysConfigService.update(config);
		}
		return R.ok().put("result",config);
	}

	/**
	 * 修改配置
	 */
	@SysLog("修改配置")
	@RequestMapping("/update")
	@RequiresPermissions("sys.config.update")
	public R update(@RequestBody SysConfigEntity config){
		ValidatorUtils.validateEntity(config);

		sysConfigService.update(config);

		return R.ok();
	}

	/**
	 * 删除配置
	 */
	@SysLog("删除配置")
	@RequestMapping("/delete")
	@RequiresPermissions("sys.config.delete")
	public R delete(@RequestBody Long[] ids){
		sysConfigService.deleteBatch(ids);
		return R.ok();
	}

}
