package com.antd.modules.security.entity.uniapp;

import lombok.Data;

import java.util.List;
@Data
public class UniRealDatas {
    //外层模块对象
    private Integer id;
    private String name;
    private List<Equipments> equipments;
    //private List<Datas> datas;

}
