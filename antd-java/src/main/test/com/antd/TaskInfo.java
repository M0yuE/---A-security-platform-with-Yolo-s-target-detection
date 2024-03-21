package com.antd;

import javafx.beans.property.SimpleIntegerProperty;
import javafx.beans.property.SimpleStringProperty;

public class TaskInfo {
    private final SimpleStringProperty taskName;
    private final SimpleIntegerProperty taskStatus;
    private final SimpleStringProperty inPath;
    private final SimpleStringProperty inMediaType;
    private final SimpleIntegerProperty inBit;
    private final SimpleStringProperty outPath;
    private final SimpleStringProperty outMediaType;
    private final SimpleIntegerProperty outBit;
    private final SimpleIntegerProperty bitRate;
    private final SimpleIntegerProperty progress;
    private final SimpleStringProperty remark;

    public TaskInfo(String taskName,  String inPath, String outPath, int bitRate, String remark) {
        this.taskName = new SimpleStringProperty(taskName);
        this.taskStatus = new SimpleIntegerProperty(0);
        this.inPath = new SimpleStringProperty(inPath);
        this.inMediaType = new SimpleStringProperty("");
        this.inBit = new SimpleIntegerProperty(0);
        this.outPath = new SimpleStringProperty(outPath);
        this.outMediaType = new SimpleStringProperty("");
        this.outBit = new SimpleIntegerProperty(0);
        this.bitRate = new SimpleIntegerProperty(bitRate);
        this.progress = new SimpleIntegerProperty(-2);
        this.remark = new SimpleStringProperty(remark);
    }

    public String getTaskName() {
        return taskName.get();
    }

    public SimpleStringProperty taskNameProperty() {
        return taskName;
    }

    public void setTaskName(String taskName) {
        this.taskName.set(taskName);
    }

    public int getTaskStatus() {
        return taskStatus.get();
    }

    public SimpleIntegerProperty taskStatusProperty() {
        return taskStatus;
    }

    public void setTaskStatus(int taskStatus) {
        this.taskStatus.set(taskStatus);
    }

    public String getInPath() {
        return inPath.get();
    }

    public SimpleStringProperty inPathProperty() {
        return inPath;
    }

    public void setInPath(String inPath) {
        this.inPath.set(inPath);
    }

    public String getOutPath() {
        return outPath.get();
    }

    public SimpleStringProperty outPathProperty() {
        return outPath;
    }

    public void setOutPath(String outPath) {
        this.outPath.set(outPath);
    }

    public int getBitRate() {
        return bitRate.get();
    }

    public SimpleIntegerProperty bitRateProperty() {
        return bitRate;
    }

    public void setBitRate(int bitRate) {
        this.bitRate.set(bitRate);
    }

    public int getProgress() {
        return progress.get();
    }

    public SimpleIntegerProperty progressProperty() {
        return progress;
    }

    public void setProgress(int progress) {
        this.progress.set(progress);
    }

    public String getRemark() {
        return remark.get();
    }

    public SimpleStringProperty remarkProperty() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark.set(remark);
    }

    public int getInBit() {
        return inBit.get();
    }

    public SimpleIntegerProperty inBitProperty() {
        return inBit;
    }

    public void setInBit(int inBit) {
        this.inBit.set(inBit);
    }

    public int getOutBit() {
        return outBit.get();
    }

    public SimpleIntegerProperty outBitProperty() {
        return outBit;
    }

    public void setOutBit(int outBit) {
        this.outBit.set(outBit);
    }

    public String getInMediaType() {
        return inMediaType.get();
    }

    public SimpleStringProperty inMediaTypeProperty() {
        return inMediaType;
    }

    public void setInMediaType(String inMediaType) {
        this.inMediaType.set(inMediaType);
    }

    public String getOutMediaType() {
        return outMediaType.get();
    }

    public SimpleStringProperty outMediaTypeProperty() {
        return outMediaType;
    }

    public void setOutMediaType(String outMediaType) {
        this.outMediaType.set(outMediaType);
    }
}
