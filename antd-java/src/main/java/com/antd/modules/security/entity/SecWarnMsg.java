package com.antd.modules.security.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import lombok.Data;

@Data
public class SecWarnMsg {
    private Integer id;
    private String msg;
    private Integer dataId;
    private String warnData;
    private Integer isRead;
    private String createTime;
    @TableField(exist = false)
    private String dataName;
    @TableField(exist = false)
    private String equipmentName;
}
