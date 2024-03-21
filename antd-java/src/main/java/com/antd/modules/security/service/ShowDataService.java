package com.antd.modules.security.service;

import com.alibaba.fastjson.JSONObject;
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

    /**
     * mockData
     * @return
     */
    //<editor-fold desc="Big screen bottom left mock data">
    public HashMap<String, List> StatisticalData() {
        HashMap<String,List> staData = new HashMap<>();
        List<String> nodeName = new ArrayList<>();
        nodeName.add("主教1");
        nodeName.add("主教2");
        nodeName.add("主教3");
        nodeName.add("主教4");
        nodeName.add("主教5");
        nodeName.add("主教6");
        nodeName.add("主教7");
        nodeName.add("主教8");
        nodeName.add("副教1");
        nodeName.add("副教2");
        nodeName.add("副教3");
        nodeName.add("副教4");
        nodeName.add("副教5");
        nodeName.add("副教6");
        nodeName.add("崇德1");
        nodeName.add("崇德2");
        nodeName.add("崇德3");
        nodeName.add("崇德4");
        nodeName.add("崇德5");
        nodeName.add("崇德6");
        nodeName.add("信工1");
        nodeName.add("信工2");
        nodeName.add("信工3");
        nodeName.add("信工4");
        nodeName.add("信工5");
        nodeName.add("电气1");
        nodeName.add("电气2");
        nodeName.add("电气3");
        nodeName.add("电气4");
        nodeName.add("电气5");
        nodeName.add("宿舍1");
        nodeName.add("宿舍2");
        nodeName.add("宿舍3");
        List<Integer> nodeData1 = new ArrayList<>();
        nodeData1.add(10);
        nodeData1.add(3);
        nodeData1.add(5);
        nodeData1.add(4);
        nodeData1.add(8);
        nodeData1.add(6);
        nodeData1.add(10);
        nodeData1.add(8);
        nodeData1.add(0);
        nodeData1.add(5);
        nodeData1.add(1);
        nodeData1.add(3);
        nodeData1.add(4);
        nodeData1.add(2);
        nodeData1.add(2);
        nodeData1.add(6);
        nodeData1.add(3);
        nodeData1.add(9);
        nodeData1.add(8);
        nodeData1.add(10);
        nodeData1.add(1);
        nodeData1.add(3);
        nodeData1.add(5);
        nodeData1.add(3);
        nodeData1.add(7);
        nodeData1.add(6);
        nodeData1.add(9);
        nodeData1.add(1);
        nodeData1.add(2);
        nodeData1.add(9);
        nodeData1.add(3);
        nodeData1.add(4);
        nodeData1.add(8);
        List<Integer> nodeData2 = new ArrayList<>();
        nodeData2.add(34);
        nodeData2.add(24);
        nodeData2.add(30);
        nodeData2.add(27);
        nodeData2.add(26);
        nodeData2.add(15);
        nodeData2.add(14);
        nodeData2.add(17);
        nodeData2.add(18);
        nodeData2.add(12);
        nodeData2.add(14);
        nodeData2.add(17);
        nodeData2.add(12);
        nodeData2.add(22);
        nodeData2.add(26);
        nodeData2.add(28);
        nodeData2.add(24);
        nodeData2.add(26);
        nodeData2.add(18);
        nodeData2.add(16);
        nodeData2.add(29);
        nodeData2.add(29);
        nodeData2.add(26);
        nodeData2.add(31);
        nodeData2.add(30);
        nodeData2.add(26);
        nodeData2.add(28);
        nodeData2.add(29);
        nodeData2.add(34);
        nodeData2.add(21);
        nodeData2.add(22);
        nodeData2.add(24);
        nodeData2.add(26);
        staData.put("nodeName",nodeName);
        staData.put("nodeData1",nodeData1);
        staData.put("nodeData2",nodeData2);
        return staData;
    }
    //</editor-fold>

}
