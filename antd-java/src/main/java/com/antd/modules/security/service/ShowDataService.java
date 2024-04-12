package com.antd.modules.security.service;

import com.alibaba.fastjson.JSONObject;
import com.antd.modules.security.dao.EchatsDeploymentDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import springfox.documentation.spring.web.json.Json;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

@Service
public class ShowDataService {

    @Autowired
    public EchatsDeploymentDao echatsDeploymentDao;

    /**
     * A function of calculating the time difference
     * @param year
     * @param month
     * @param day
     * @return
     */
    public Integer calculateTimeDifferenceByChronoUnit(Integer year,Integer month, Integer day) {
        LocalDate startDate = LocalDate.now();
        LocalDate endDate = LocalDate.of(year,month,day);
        long daysDiff = ChronoUnit.DAYS.between(startDate,endDate);
        Integer days = new Long(daysDiff).intValue();
        return days;
    }

    public HashMap<String, Integer> timeDiff() {
        HashMap<String, Integer> timeDifferences = new HashMap<>();
        Integer postgraduateExams = calculateTimeDifferenceByChronoUnit(2021,12,25);
        Integer EnglishCET = calculateTimeDifferenceByChronoUnit(2021,12,18);
        Integer Olympics = calculateTimeDifferenceByChronoUnit(2022,2,4);
        Integer SpringFestival = calculateTimeDifferenceByChronoUnit(2022,2,1);
        timeDifferences.put("postgraduateExams",postgraduateExams);
        timeDifferences.put("EnglishCET",EnglishCET);
        timeDifferences.put("Olympics",Olympics);
        timeDifferences.put("SpringFestival",SpringFestival);
        return timeDifferences;
    }

    public void test(){

    }


    /**
     * mockData
     * @return
     */
    //<editor-fold desc="Big screen bottom left mock data">
    public HashMap<String, List> StatisticalData() {
        HashMap<String,List> staData = new HashMap<>();
        List<String> category = echatsDeploymentDao.getCategory(); //部署地点(种类)

        List<Integer> lineData = echatsDeploymentDao.getLineData(); //已部署

        List<Integer> barData = echatsDeploymentDao.getBarData(); //计划部署

        staData.put("category",category);
        staData.put("lineData",lineData);
        staData.put("barData",barData);
        return staData;
    }
    //</editor-fold>

}
