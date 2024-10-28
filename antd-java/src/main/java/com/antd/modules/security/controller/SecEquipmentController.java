package com.antd.modules.security.controller;

import com.antd.common.annotation.SysLog;
import com.antd.common.utils.PageUtils;
import com.antd.common.utils.R;
import com.antd.modules.security.entity.SecConnectModular;
import com.antd.modules.security.entity.SecData;
import com.antd.modules.security.entity.SecEquipment;
import com.antd.modules.security.entity.SecInstruct;
import com.antd.modules.security.service.SecEquipmentService;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.Arrays;
import java.util.Map;

@RestController
@RequestMapping("/sec/equipment")
public class SecEquipmentController {
    @Autowired
    private SecEquipmentService secEquipmentService;

    @RequestMapping("/modularList")
    @RequiresPermissions("connectEquipment.equipment.modularList")
    public R modularList(@RequestParam Map<String, Object> params){
        PageUtils page = secEquipmentService.queryModularPage(params);
        return R.ok().put("page", page);
    }
    @RequestMapping("/modularSaveOrUpdate")
    @SysLog("保存或修改模块")
    @RequiresPermissions("connectEquipment.equipment.modularWrite")
    public R modularSaveOrUpdate(@RequestBody SecConnectModular secConnectModular){
        secEquipmentService.modularSaveOrUpdate(secConnectModular);
        return R.ok();
    }
    @RequestMapping("/modularDelete")
    @SysLog("删除模块")
    @RequiresPermissions("connectEquipment.equipment.modularDelete")
    public R modularDelete(@RequestBody Integer[] ids){
        secEquipmentService.modularDelete(Arrays.asList(ids));
        return R.ok();
    }
    @RequestMapping("/equipmentList")
    @RequiresPermissions("connectEquipment.equipment.equipmentList")
    public R equipmentList(@RequestParam Map<String, Object> params){
        PageUtils page = secEquipmentService.queryEquipmentPage(params);
        return R.ok().put("page", page);
    }
    @RequestMapping("/equipmentSaveOrUpdate")
    @SysLog("保存或修改设备")
    @RequiresPermissions("connectEquipment.equipment.equipmentWrite")
    public R equipmentSaveOrUpdate(@RequestBody SecEquipment secEquipment){
        secEquipmentService.equipmentSaveOrUpdate(secEquipment);
        return R.ok();
    }
    @RequestMapping("/equipmentDelete")
    @SysLog("删除设备")
    @RequiresPermissions("connectEquipment.equipment.equipmentDelete")
    public R equipmentDelete(@RequestBody Integer[] ids){
        secEquipmentService.equipmentDelete(Arrays.asList(ids));
        return R.ok();
    }
    @RequestMapping("/instructList")
    @RequiresPermissions("connectEquipment.equipment.instructList")
    public R instructList(@RequestParam Map<String, Object> params){
        PageUtils page = secEquipmentService.queryInstructPage(params);
        return R.ok().put("page", page);
    }
    @RequestMapping("/getDataListByInstructId")
    @RequiresPermissions("connectEquipment.equipment.instructList")
    public R getDataListByInstructId(Integer id){
        return R.ok().put("list", secEquipmentService.getDataListByInstructId(id));
    }

    @RequestMapping("/instructSaveOrUpdate")
    @SysLog("保存或修改指令")
    @RequiresPermissions("connectEquipment.equipment.instructWrite")
    public R instructSaveOrUpdate(@RequestBody SecInstruct secInstruct){
        secEquipmentService.instructSaveOrUpdate(secInstruct);
        return R.ok();
    }

    @RequestMapping("/instructDelete")
    @SysLog("删除指令")
    @RequiresPermissions("connectEquipment.equipment.instructDelete")
    public R instructDelete(@RequestBody Integer[] ids){
        secEquipmentService.instructDelete(Arrays.asList(ids));
        return R.ok();
    }
    @RequestMapping("/dataList")
    @RequiresPermissions("connectEquipment.equipment.dataList")
    public R dataList(@RequestParam Map<String, Object> params){
        PageUtils page = secEquipmentService.queryDataPage(params);
        return R.ok().put("page", page);
    }
    @RequestMapping("/dataSaveOrUpdate")
    @SysLog("保存或修改数据项")
    @RequiresPermissions("connectEquipment.equipment.dataWrite")
    public R dataSaveOrUpdate(@RequestBody SecData secData){
        secEquipmentService.dataSaveOrUpdate(secData);
        return R.ok();
    }
    @RequestMapping("/dataDelete")
    @SysLog("删除数据项")
    @RequiresPermissions("connectEquipment.equipment.dataDelete")
    public R dataDelete(@RequestBody Integer[] ids){
        secEquipmentService.dataDelete(Arrays.asList(ids));
        return R.ok();
    }
    @RequestMapping("/parseData")
    public R parseData(SecData secData){
        return secEquipmentService.parseData(secData);
    }

    @RequestMapping("/sendInstruct")
    @SysLog("手动发送指令")
    @RequiresPermissions("connectEquipment.equipment.sendInstruct")
    public R sendInstruct(Integer id){
        return secEquipmentService.sendInstruct(id);
    }

    @RequestMapping("/uniControllerData")
    @SysLog("获取控制界面数据")
    //@RequiresPermissions("connectEquipment.equipment.uniControllerData")
    public R uniControllerData(){
        return secEquipmentService.getUniAppControllerData();
    }

    @RequestMapping("/uniSendInstruct")
    @SysLog("手动发送UniApp端指令")
    //@RequiresPermissions("connectEquipment.equipment.uniSendInstruct")
    public R uniSendInstruct(Integer id){
        return secEquipmentService.uniSendInstruct(id);
    }
}
