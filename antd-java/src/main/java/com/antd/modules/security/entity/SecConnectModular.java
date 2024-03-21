package com.antd.modules.security.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import lombok.Data;

import java.util.List;

@Data
public class SecConnectModular {
    private Integer id;
    private String name;
    private String remark;
    private Integer connectId;
    private Integer queryInterval;
    private Integer instructInterval;
    private String verify;
    @TableField(exist = false)
    private String connectName;
    @TableField(exist = false)
    private Integer isUp = 0;
    @TableField(exist = false)
    List<SecInstruct> instructList;
}
