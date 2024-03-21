package com.antd.modules.security.connect;

import com.antd.modules.security.entity.SecConnectModular;
import com.antd.modules.security.entity.SecData;
import lombok.Data;

@Data
public class ResultData {
    private int id;
    private String data;
    private SecData secData;
    private boolean modularUp;
    private SecConnectModular secConnectModular;
}
