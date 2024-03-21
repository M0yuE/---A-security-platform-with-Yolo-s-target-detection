package com.antd.modules.security.controller;


import com.antd.common.utils.PageUtils;
import com.antd.common.utils.R;
import com.antd.modules.security.entity.SecVideo;
import com.antd.modules.security.service.SecVideoService;
import com.antd.modules.sys.controller.AbstractController;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.Arrays;
import java.util.Map;

@RestController
@RequestMapping("/sec/video")
public class SecVideoController extends AbstractController {
	@Autowired
	private SecVideoService secVideoService;
	@RequestMapping("/list")
	public R list(@RequestParam Map<String, Object> params){
		PageUtils page = secVideoService.queryPage(params);
		return R.ok().put("page", page);
	}
	@RequestMapping("/saveOrUpdate")
	public R save(@RequestBody SecVideo record){
		Integer id = record.getId();
		if(id != null){
			secVideoService.updateById(record);
		}else{
			secVideoService.save(record);
		}
		return R.ok();
	}

	@RequestMapping("/delete")
	public R delete(@RequestBody Long[] ids){
		secVideoService.removeByIds(Arrays.asList(ids));
		return R.ok();
	}
}
