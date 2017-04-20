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

package com.ls.widgets.map.commands;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.TransitionDrawable;
import android.os.AsyncTask;

import java.io.IOException;
import java.io.InputStream;

public class GetTileTask extends AsyncTask<Integer, Integer, Boolean> {

    private InputStream is;
    private Drawable result; // 最终转换后的Drawable
    private static final Drawable transparent = new ColorDrawable(Color.TRANSPARENT); // 透明Drawable

    public GetTileTask(InputStream is) {
        this.is = is;
    }


    public Drawable getResult() {
        return result;
    }


    public void closeStream() throws IOException {
        is.close();
    }

    // 后台任务
    @Override
    protected Boolean doInBackground(Integer... params) {
        BitmapDrawable tileDrawable;
        try {
            Bitmap bitmap = BitmapFactory.decodeStream(is); // 解析InputStream获取Bitmap
            if (bitmap != null) {
                tileDrawable = new BitmapDrawable(bitmap);
                result = new TransitionDrawable(new Drawable[]{transparent, tileDrawable});
                result.setBounds(0, 0, tileDrawable.getBitmap().getWidth(), tileDrawable.getBitmap().getHeight());
                return true;
            } else {
                return false;
            }
        } catch (OutOfMemoryError e) {
            return false;
        }
    }
}
