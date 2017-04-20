package com.example;

/**
 * Created by nealkyliu on 2017/4/5.
 */
public class AcoParameters {
    private double Alpha;
    private double Beta;
    private double Rho;
    private double Q;
    private int cycle_max;
    private int ant_num;

    public AcoParameters() {
    }

    public AcoParameters(double alpha, double beta, double rho, double q, int cycle_max, int ant_num) {
        Alpha = alpha;
        Beta = beta;
        Rho = rho;
        Q = q;
        this.cycle_max = cycle_max;
        this.ant_num = ant_num;
    }

    public double getAlpha() {
        return Alpha;
    }

    public void setAlpha(double alpha) {
        Alpha = alpha;
    }

    public double getBeta() {
        return Beta;
    }

    public void setBeta(double beta) {
        Beta = beta;
    }

    public double getRho() {
        return Rho;
    }

    public void setRho(double rho) {
        Rho = rho;
    }

    public double getQ() {
        return Q;
    }

    public void setQ(double q) {
        Q = q;
    }

    public int getCycle_max() {
        return cycle_max;
    }

    public void setCycle_max(int cycle_max) {
        this.cycle_max = cycle_max;
    }

    public int getAnt_num() {
        return ant_num;
    }

    public void setAnt_num(int ant_num) {
        this.ant_num = ant_num;
    }
}
