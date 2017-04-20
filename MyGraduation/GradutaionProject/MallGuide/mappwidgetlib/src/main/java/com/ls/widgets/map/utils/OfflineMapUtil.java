/*************************************************************************
 * Copyright (c) 2015 Lemberg Solutions
 * <p/>
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * <p/>
 * http://www.apache.org/licenses/LICENSE-2.0
 * <p/>
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **************************************************************************/

package com.ls.widgets.map.utils;

// =========== 离线Map转换工具 ========= //
public class OfflineMapUtil {
    private static String filesPathCache;
    private static String cachedRoot;
    public static float SCALEP_PROP = 2f;

    public static String getConfigFilePath(String root) {
        if (root == null) {
            throw new IllegalArgumentException("root can't be null");
        }

        if (root.lastIndexOf('/') == -1) {
            return root + "/" + root + ".xml";
        } else {
            return root + "/" + extractMapName(root) + ".xml";
        }
    }


    public static String getFilesPath(String root) {
        if (root == null) {
            throw new IllegalArgumentException("root can't be null");
        }

        if (filesPathCache != null && cachedRoot.hashCode() == root.hashCode())
            return filesPathCache;

        if (root.lastIndexOf('/') == -1) {
            filesPathCache = root + "/" + root + "_files/";
            cachedRoot = root;
            return filesPathCache;
        } else {
            int indexOfSlash = root.lastIndexOf('/');

            if (indexOfSlash != -1) {
                filesPathCache = root + "/" + extractMapName(root) + "_files/";
                cachedRoot = root;
            }

            return filesPathCache;
        }
    }


    // 根据图片像素大小获取当前图片能够缩放的level级别大小（假设每次缩放比例SCALEP_PROP为2，则
    // 得到的maxLevel=lg size / lg 2）
    public static int getMaxZoomLevel(int imageWidth, int imageHeight) {
        int biggerSize = imageWidth > imageHeight ? imageWidth : imageHeight;

        if (biggerSize == 0) {
            return 0;
        }

        return (int) Math.ceil(Math.log((double) biggerSize) / Math.log(SCALEP_PROP));
    }


    // 获得Level改变之后，图片比例的变化
    public static int getScaledImageSize(int maxZoomLevel, int currZoomLevel, int size) {
        double scale = 1.0 / Math.pow(SCALEP_PROP, maxZoomLevel - currZoomLevel);

        return (int) Math.ceil(size * scale);
    }


    // 获取当前的缩放比例
    public static float getScalepProp () {
        return SCALEP_PROP;
    }

    // 设置ScaleProp
    public static void setScaleProp(float scale_prop) {
        SCALEP_PROP = scale_prop;
    }

    private static String extractMapName(String root) {
        int indexOfSlash = root.lastIndexOf('/');

        if (indexOfSlash != -1) {
            return root.substring(indexOfSlash + 1);
        }

        return root;
    }

}
