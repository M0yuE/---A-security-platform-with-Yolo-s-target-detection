package com.antd.modules.security.service;

import com.antd.common.utils.PageUtils;
import com.antd.common.utils.Query;
import com.antd.modules.security.dao.SecVideoDao;
import com.antd.modules.security.entity.SecVideo;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;

import java.util.Map;

@Service
public class SecVideoService extends ServiceImpl<SecVideoDao, SecVideo> {
    public PageUtils queryPage(Map<String, Object> params) {
        String paramKey = (String)params.get("name");
        IPage<SecVideo> page = this.page(
                new Query<SecVideo>().getPage(params),
                new QueryWrapper<SecVideo>()
                        .like(StringUtils.isNotBlank(paramKey),"name", paramKey)
        );
        return new PageUtils(page);
    }
}
