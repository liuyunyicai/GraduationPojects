package com.example;

/**
 * Created by nealkyliu on 2017/4/5.
 * Fire火灾的相关参数
 */
public class FireParameters {
    private double warning_time; // 火灾报警时火灾发生的时间

    public FireParameters() {
    }

    public FireParameters(double warning_time) {
        this.warning_time = warning_time;
    }

    public double getWarning_time() {
        return warning_time;
    }

    public void setWarning_time(double warning_time) {
        this.warning_time = warning_time;
    }
}
