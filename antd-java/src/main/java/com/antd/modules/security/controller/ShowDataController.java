package com.antd.modules.security.controller;

import com.antd.common.utils.R;
import com.antd.modules.security.entity.EchartsShowDataStorage;
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
    @Autowired
    private EchartsShowDataStorage dataStorage;

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


    @RequestMapping("/SmokeData")
    public R smokingData(){
        //先从临时库中获取到原始数据
        //然后检测是否为烟雾数据,如果是,则可以发送给前端
        // 烟雾 000501aaaa
        String SmokeData = dataStorage.getDataStorage("dataStorage");
        if(SmokeData.charAt(4) == '5'){ //第四位上是'5' , 即这串是烟雾传感器
            return R.ok().put("SmokeData",SmokeData);
        }else{
            return R.error("烟雾传感器状态异常!");
        }
    }

}
