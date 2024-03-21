package com.antd.modules.security.entity;

import com.antd.modules.security.entity.uniapp.Datas;
import com.baomidou.mybatisplus.annotation.TableField;
import lombok.Data;

import java.util.List;

@Data
public class SecEquipment {
    private Integer id;
    private Integer modularId;
    private String name;
    private String remark;
    @TableField(exist = false)
    private String modularName;
}
