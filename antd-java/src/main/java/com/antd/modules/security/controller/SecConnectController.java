package com.antd.modules.security.controller;

import com.antd.common.annotation.SysLog;
import com.antd.common.utils.PageUtils;
import com.antd.common.utils.R;
import com.antd.modules.security.entity.SecConnect;
import com.antd.modules.security.service.SecConnectService;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("/sec/connect")
public class SecConnectController {
    @Autowired
    private SecConnectService secConnectService;
    @RequestMapping("/list")
    @RequiresPermissions("connectEquipment.connect.list")
    public R list(@RequestParam Map<String, Object> params){
        PageUtils page = secConnectService.queryPage(params);
        return R.ok().put("page", page);
    }
    @RequestMapping("/listAll")
    @RequiresPermissions("connectEquipment.connect.list")
    public R listAll(){
        return R.ok().put("list", secConnectService.getAllConnectWithCount());
    }
    @SysLog("保存或修改连接")
    @RequestMapping("/saveOrUpdate")
    @RequiresPermissions("connectEquipment.connect.write")
    public R saveOrUpdate(@RequestBody SecConnect secConnect){
        secConnectService.saveOrUpdateConnect(secConnect);
        return R.ok();
    }
    @SysLog("删除连接")
    @RequestMapping("/delete")
    @RequiresPermissions("connectEquipment.connect.delete")
    public R delete(@RequestBody Long[] ids){
        secConnectService.deleteConnect(ids);
        return R.ok();
    }
}
