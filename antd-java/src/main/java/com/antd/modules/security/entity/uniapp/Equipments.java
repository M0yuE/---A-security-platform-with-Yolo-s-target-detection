package com.antd.modules.security.entity.uniapp;

import lombok.Data;

import java.util.List;

@Data
public class Equipments {
    //中层设备对象
    private Integer id;
    private String name;
    private List<Datas> datas;
}
