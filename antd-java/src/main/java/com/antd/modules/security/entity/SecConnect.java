package com.antd.modules.security.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import lombok.Data;

import java.util.List;
import java.util.Objects;

@Data
public class SecConnect {
    private Integer id;
    private String name;
    private Integer port;
    private Integer type;
    private Integer single;
    @TableField(exist = false)
    private Integer connectCount;
    @TableField(exist = false)
    private Integer status;//1开启0未开启
    private String create_time;
    @TableField(exist = false)
    private List<SecConnectModular> upModularList;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        SecConnect that = (SecConnect) o;
        return Objects.equals(id, that.id);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }
}
