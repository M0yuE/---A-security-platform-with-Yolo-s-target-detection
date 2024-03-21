package com.antd.modules.security.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import lombok.Data;

@Data
public class SecData {
    private Integer id;
    private String name;
    private Integer instructId;
    private Integer cacheTime;
    private Integer start;
    private Integer length;
    private Integer highLowConvert;
    private Integer convertTo;
    private Integer cut;
    private Integer cutStart;
    private Integer cutLength;
    private Integer dataWarn;
    private Integer warnOption;
    private String warnType;
    private String warnValue;
    private Integer bindData;
    @TableField(exist = false)
    private String instructName;
    @TableField(exist = false)
    private String retExample;
    @TableField(exist = false)
    private String equipmentName;
    @TableField(exist = false)
    private Integer equipmentId;
    @TableField(exist = false)
    private String fetchTime;
    @TableField(exist = false)
    private String curData;
}
