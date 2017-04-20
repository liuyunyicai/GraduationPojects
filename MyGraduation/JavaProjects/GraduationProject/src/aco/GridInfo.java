package aco;

/*
* 每个栅格基本信息
**/
public class GridInfo {

    public int gridType; // 柵格类型
    public int isFree;
    public float temperature;
    public float smokeCon;
    public float O2Con;
    public float COCon;
    public float CO2Con;
    public int peopleNum;

    public GridInfo() {}

    public GridInfo(int gridType, int isFree, float temperature, float smokeCon, float o2Con, float COCon, float CO2Con, int peopleNum) {
        this.gridType = gridType;
        this.isFree = isFree;
        this.temperature = temperature;
        this.smokeCon = smokeCon;
        O2Con = o2Con;
        this.COCon = COCon;
        this.CO2Con = CO2Con;
        this.peopleNum = peopleNum;
    }

    public int getGridType() {
        return gridType;
    }

    public void setGridType(int gridType) {
        this.gridType = gridType;
    }

    public int getIsFree() {
        return isFree;
    }

    public void setIsFree(int isFree) {
        this.isFree = isFree;
    }

    public float getTemperature() {
        return temperature;
    }

    public void setTemperature(float temperature) {
        this.temperature = temperature;
    }

    public float getSmokeCon() {
        return smokeCon;
    }

    public void setSmokeCon(float smokeCon) {
        this.smokeCon = smokeCon;
    }

    public float getO2Con() {
        return O2Con;
    }

    public void setO2Con(float o2Con) {
        O2Con = o2Con;
    }

    public float getCOCon() {
        return COCon;
    }

    public void setCOCon(float COCon) {
        this.COCon = COCon;
    }

    public float getCO2Con() {
        return CO2Con;
    }

    public void setCO2Con(float CO2Con) {
        this.CO2Con = CO2Con;
    }

    public int getPeopleNum() {
        return peopleNum;
    }

    public void setPeopleNum(int peopleNum) {
        this.peopleNum = peopleNum;
    }
}
