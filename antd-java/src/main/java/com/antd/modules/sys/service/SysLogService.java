package com.antd.modules.sys.service;


import com.baomidou.mybatisplus.extension.service.IService;
import com.antd.modules.sys.entity.SysLogEntity;
import com.antd.common.utils.PageUtils;

import java.util.Map;

public interface SysLogService extends IService<SysLogEntity> {

    PageUtils queryPage(Map<String, Object> params);

}
