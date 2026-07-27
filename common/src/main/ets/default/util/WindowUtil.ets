/*
 * Copyright (c) Huawei Device Co., Ltd. 2026. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { UIContext, window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import Logger from './Logger';
import { WindowInfo } from './WindowInfo';

/** 窗口断点监听与信息维护 */
export class WindowUtil {
  private mainWindow: window.Window;
  private uiContext?: UIContext;
  public mainWindowInfo: WindowInfo = new WindowInfo();

  /**
   * 构造函数，初始化窗口工具类
   * @param mainWindow - 主窗口实例
   */
  constructor(mainWindow: window.Window) {
    this.mainWindow = mainWindow;
  }

  /**
   * 设置 UI 上下文对象
   * 从主窗口获取 UIContext，用于后续获取窗口断点信息
   */
  setUIContext(): void {
    try {
      this.uiContext = this.mainWindow.getUIContext();
    } catch (err) {
      Logger.error('setUIContext error: ' + JSON.stringify(err));
    }
  }

  /**
   * 窗口尺寸变化回调函数
   * 当窗口尺寸发生变化时自动触发，更新窗口信息并通知订阅方
   * @param windowSize - 变化后的窗口尺寸对象
   */
  public onWindowSizeChange: (windowSize: window.Size) => void = (windowSize: window.Size) => {
    this.mainWindowInfo.windowSize = windowSize;
    if (this.uiContext) {
      this.mainWindowInfo.widthBp = this.uiContext.getWindowWidthBreakpoint();
      this.mainWindowInfo.heightBp = this.uiContext.getWindowHeightBreakpoint();
    }
    AppStorage.set('mainWindowInfo', this.mainWindowInfo);
  };

  /**
   * 更新窗口信息并注册窗口尺寸变化监听器
   * 初始化窗口信息数据，并开始监听窗口尺寸变化事件
   */
  updateWindowInfo(): void {
    try {
      const rect = this.mainWindow.getWindowProperties().windowRect;
      this.mainWindowInfo.windowSize = { width: rect.width, height: rect.height };
      if (this.uiContext) {
        this.mainWindowInfo.widthBp = this.uiContext.getWindowWidthBreakpoint();
        this.mainWindowInfo.heightBp = this.uiContext.getWindowHeightBreakpoint();
      }
      this.mainWindow.on('windowSizeChange', this.onWindowSizeChange);
    } catch (error) {
      const err = error as BusinessError;
      Logger.error(`Failed to update window info. Code: ${err.code}, message: ${err.message}`);
    }
  }

  /**
   * 销毁方法，清理资源
   * 移除窗口尺寸变化事件的监听器，防止内存泄漏
   */
  destroy(): void {
    try {
      this.mainWindow.off('windowSizeChange', this.onWindowSizeChange);
    } catch (err) {
      Logger.error('windowSizeChange off error: ' + JSON.stringify(err));
    }
  }
}
