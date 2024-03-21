package com.antd.modules.security.controller;

import com.antd.common.annotation.SysLog;
import com.antd.common.utils.PageUtils;
import com.antd.common.utils.R;
import com.antd.modules.security.entity.SecWarnMsg;
import com.antd.modules.security.service.SecWarnMsgService;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import io.swagger.models.auth.In;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/sec/warnMsg")
public class SecWarnMsgController {
    @Autowired
    private SecWarnMsgService secWarnMsgService;
    @RequestMapping("/list")
    @RequiresPermissions("secData.warnMsg.list")
    public R list(@RequestParam Map<String, Object> params){
        PageUtils page = secWarnMsgService.queryPage(params);
        return R.ok().put("page", page);
    }
    @SysLog("标记消息已读")
    @RequestMapping("/read")
    @RequiresPermissions("secData.warnMsg.read")
    public R delete(@RequestBody Long[] ids){
        secWarnMsgService.readMsg(ids);
        return R.ok();
    }
    @RequestMapping("/warnCount")
    public R warnCount(){
        int warnCount = secWarnMsgService.count(new QueryWrapper<SecWarnMsg>().eq("is_read", 0));
        return R.ok().put("count",warnCount);
    }

    @RequestMapping("/uniDataWarnMsg")
    public R uniDataWarnMsg(){
        List<SecWarnMsg> secWarnMsgList = secWarnMsgService.uniQueryDataList();
        return R.ok().put("messages",secWarnMsgList);
    }

    @RequestMapping("/uniReadWarnMsg")
    public R uniReadWarnMsg(Integer id){
        List<SecWarnMsg> secWarnMsgList = secWarnMsgService.uniReadWarnMsg(id);
        return R.ok().put("messages",secWarnMsgList);
    }

    @RequestMapping("/uniDeleteWarnMsg")
    public R uniDeleteWarnMsg(Integer id){
        System.out.println(id);
        List<SecWarnMsg> secWarnMsgList = secWarnMsgService.uniDeleteWarnMsg(id);
        return R.ok().put("messages",secWarnMsgList);
    }
}
