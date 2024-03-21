package com.antd.modules.security.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import lombok.Data;

@Data
public class SecInstruct {
    private Integer id;
    private Integer equipmentId;
    private String name;
    private Integer type;
    private String instruct;
    private String retExample;
    @TableField(exist = false)
    private String equipmentName;
    @TableField(exist = false)
    private Integer modularId;
    @TableField(exist = false)
    private Integer connectId;
}
