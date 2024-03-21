package com.antd.modules.job.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.antd.modules.job.entity.ScheduleJobLogEntity;
import com.antd.common.utils.PageUtils;

import java.util.Map;
public interface ScheduleJobLogService extends IService<ScheduleJobLogEntity> {

	PageUtils queryPage(Map<String, Object> params);
	
}
