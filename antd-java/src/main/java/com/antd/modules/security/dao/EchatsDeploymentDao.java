package com.antd.modules.security.dao;


import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface EchatsDeploymentDao {

    @Select("select category from echarts_deployment")
    List<String> getCategory();

    @Select("select line_data from echarts_deployment")
    List<Integer> getLineData();

    @Select("select bar_data from echarts_deployment")
    List<Integer> getBarData();
}
