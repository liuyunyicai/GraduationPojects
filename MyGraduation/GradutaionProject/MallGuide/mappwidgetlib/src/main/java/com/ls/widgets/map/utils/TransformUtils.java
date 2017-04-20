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

import android.graphics.Matrix;
import android.graphics.Rect;
/** 转换工具 **/
public class TransformUtils {
    private static final Matrix matrix = new Matrix();

    // 进行转换
    public static Rect scaleRect(Rect coords, float scale, int pivotX, int pivotY) {
        matrix.reset();
        matrix.setScale(scale, scale, pivotX, pivotY);

        float[] result = {coords.left, coords.top, coords.right, coords.bottom};
        matrix.mapPoints(result);

        return new Rect((int) result[0], (int) result[1], (int) result[2], (int) result[3]);
    }
}
