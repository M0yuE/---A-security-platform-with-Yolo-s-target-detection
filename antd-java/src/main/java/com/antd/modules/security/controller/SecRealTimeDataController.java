package com.antd.modules.security.controller;

import com.antd.common.utils.PageUtils;
import com.antd.common.utils.R;
import com.antd.modules.security.service.SecRealTimeDataService;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("/sec/realTimeData")
public class SecRealTimeDataController {
    @Autowired
    private SecRealTimeDataService secRealTimeDataService;
    @RequestMapping("/list")
    @RequiresPermissions("secData.realTimeData.list")
    public R list(@RequestParam Map<String, Object> params){
        PageUtils page = secRealTimeDataService.queryPage(params);
        return R.ok().put("page", page);
    }
    @RequestMapping("/modularsAndEquipments")
    public R modularsAndEquipments(){
        return secRealTimeDataService.modularsAndEquipments();
    }

    @GetMapping("/uniappRealData")
    public R getUniappRealData(){
        return secRealTimeDataService.getUniAppRealTimeData();
    }
}
