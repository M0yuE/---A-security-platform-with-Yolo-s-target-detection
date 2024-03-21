package com.antd.modules.security.controller;

import com.antd.common.utils.R;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;

@RestController
@RequestMapping("/wap")
public class WapController {
    @RequestMapping("/info")
    public R info(String params, HttpServletRequest request){
        String token = request.getHeader("token");
        System.out.println(token);
        System.out.println(params);
        return R.ok();
    }
}
