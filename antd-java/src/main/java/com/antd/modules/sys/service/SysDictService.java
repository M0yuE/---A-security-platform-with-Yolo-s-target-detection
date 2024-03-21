package com.antd.modules.sys.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.antd.modules.sys.entity.SysDictEntity;
import com.antd.common.utils.PageUtils;

import java.util.Map;
public interface SysDictService extends IService<SysDictEntity> {

    PageUtils queryPage(Map<String, Object> params);
}

