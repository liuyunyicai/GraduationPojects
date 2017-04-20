package com.example;

/**
 * Created by nealkyliu on 2017/4/5.
 */
public class AcoAlgorithm {
    private GridInfo[][][] mGridInfos;
    private int[] mEntranceGrid; // 入口点
    private int[][] mExitGrids;  // 出口点
    private int[][] mFireGrids;
    private int[][] mPreferedGrids;
    private AcoParameters mAcoParameters;
    private GridParameters mGridParameters;
    private FireParameters mFireParameters;

    public AcoAlgorithm() {
    }

    public AcoAlgorithm(GridInfo[][][] mGridInfos, int[] mEntranceGrid, int[][] mExitGrids, int[][] mFireGrids, int[][] mPreferedGrids, AcoParameters mAcoParameters, GridParameters mGridParameters, FireParameters mFireParameters) {
        this.mGridInfos = mGridInfos;
        this.mEntranceGrid = mEntranceGrid;
        this.mExitGrids = mExitGrids;
        this.mFireGrids = mFireGrids;
        this.mPreferedGrids = mPreferedGrids;
        this.mAcoParameters = mAcoParameters;
        this.mGridParameters = mGridParameters;
        this.mFireParameters = mFireParameters;
    }

    public GridInfo[][][] getmGridInfos() {
        return mGridInfos;
    }

    public void setmGridInfos(GridInfo[][][] mGridInfos) {
        this.mGridInfos = mGridInfos;
    }

    public int[] getmEntranceGrid() {
        return mEntranceGrid;
    }

    public void setmEntranceGrid(int[] mEntranceGrid) {
        this.mEntranceGrid = mEntranceGrid;
    }

    public int[][] getmExitGrids() {
        return mExitGrids;
    }

    public void setmExitGrids(int[][] mExitGrids) {
        this.mExitGrids = mExitGrids;
    }

    public int[][] getmFireGrids() {
        return mFireGrids;
    }

    public void setmFireGrids(int[][] mFireGrids) {
        this.mFireGrids = mFireGrids;
    }

    public int[][] getmPreferedGrids() {
        return mPreferedGrids;
    }

    public void setmPreferedGrids(int[][] mPreferedGrids) {
        this.mPreferedGrids = mPreferedGrids;
    }

    public AcoParameters getmAcoParameters() {
        return mAcoParameters;
    }

    public void setmAcoParameters(AcoParameters mAcoParameters) {
        this.mAcoParameters = mAcoParameters;
    }

    public GridParameters getmGridParameters() {
        return mGridParameters;
    }

    public void setmGridParameters(GridParameters mGridParameters) {
        this.mGridParameters = mGridParameters;
    }

    public FireParameters getmFireParameters() {
        return mFireParameters;
    }

    public void setmFireParameters(FireParameters mFireParameters) {
        this.mFireParameters = mFireParameters;
    }
}
