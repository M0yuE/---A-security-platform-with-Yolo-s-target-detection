package com.antd.modules.security.controller;

import com.antd.common.utils.R;
import com.antd.modules.security.service.ShowDataService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;

@RestController
@RequestMapping("/showData")
public class ShowDataController {
    @Autowired
    private ShowDataService showDataService;

    @RequestMapping("/timeDifference")
    public R TimeDifference() {
        HashMap<String, Integer> timeDiff = showDataService.timeDiff();
        return R.ok().put("timeDifference",timeDiff);
    }

    @RequestMapping("/NodeData")
    public R StatisticalData() {
        HashMap<String, List> mockDataNode = showDataService.StatisticalData();
        return R.ok().put("NodeMockData",mockDataNode);
    }

}
