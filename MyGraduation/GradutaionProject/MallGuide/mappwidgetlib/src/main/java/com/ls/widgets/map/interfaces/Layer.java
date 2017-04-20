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

package com.ls.widgets.map.interfaces;

import com.ls.widgets.map.model.MapLine;
import com.ls.widgets.map.model.MapObject;
import com.ls.widgets.map.model.MapText;

// Layer的抽象接口
public interface Layer {
    // MapObject相关操作
    public void addMapObject(MapObject mapObject);
    public void removeMapObject(Object id);
    public MapObject getMapObject(Object id);
    public MapObject getMapObjectByIndex(int index);
    public int getMapObjectCount();
    public void clearAll();

    public boolean isVisible();
    public void setVisible(boolean visible);


    // 操作line相关
    public void addMapLine(MapLine mapLine);
    public void removeMapLine(MapLine mapLine);
    public void removeMapLineById(int lineId);
    public MapLine getMapLine(int id);
    public MapLine getMapLineByTag(String tag);
    public int getMapLineCount();
    public void clearAllLines();

    // 和Text操作相关
    public void addMapText(MapText mapText);
    public void removeMapText(MapText mapText);
    public void removeMapTextById(int textId);
    public MapText getMapText(int id);
    public MapText getMapTextByTag(String tag);
    public int getMapTextCount();
    public void clearAllMapTexts();
}
