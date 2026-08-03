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
import { display, window } from '@kit.ArkUI';

/** 配图尺寸 */
export interface DetailImageSize {
  width: number;
  height: number;
}

export class DetailResponsiveLayoutUtil {
  /** 宽高比阈值：9/7.2 = 1.25 */
  public static readonly ASPECT_THRESHOLD: number = 9 / 7.2;
  /** 配图宽高比例：4:3 */
  public static readonly IMAGE_ASPECT_WIDTH: number = 4;
  public static readonly IMAGE_ASPECT_HEIGHT: number = 3;
  /** pad 配图宽度：屏幕短边的 80% */
  public static readonly IMAGE_SHORT_SIDE_RATIO: number = 0.8;
  /** pad 横屏文本区域宽度：屏幕长边的 40% */
  public static readonly TEXT_LONG_SIDE_RATIO: number = 0.4;
  public static readonly TEXT_MARGIN_2M: number = 16;

  /** lg/xl 横向断点（≥840vp） */
  static is12C(widthBp: WidthBreakpoint): boolean {
    return widthBp === WidthBreakpoint.WIDTH_LG || widthBp === WidthBreakpoint.WIDTH_XL;
  }

  /** px 转 vp，与 BreakpointUtil 换算方式一致 */
  private static pxToVp(px: number): number {
    const dpi: number = display.getDefaultDisplaySync().densityPixels;
    return px / dpi;
  }

  /**
   * 是否满足左右布局：12C（横向断点≥840vp）且 宽÷高 >= 9/7.2
   * @param widthBp 横向断点（媒体查询）
   * @param windowSize 窗口尺寸 px
   */
  static isSideBySide(widthBp: WidthBreakpoint, windowSize: window.Size): boolean {
    if (!DetailResponsiveLayoutUtil.is12C(widthBp) ||
      windowSize.width <= 0 || windowSize.height <= 0) {
      return false;
    }
    const aspectRatio: number = windowSize.width / windowSize.height;
    return aspectRatio >= DetailResponsiveLayoutUtil.ASPECT_THRESHOLD;
  }

  /** 计算 4:3 配图尺寸（vp），宽度 = 屏幕短边 × 80% */
  static getImageSize(windowSize: window.Size): DetailImageSize {
    const shortSideVp = Math.min(
      DetailResponsiveLayoutUtil.pxToVp(windowSize.width),
      DetailResponsiveLayoutUtil.pxToVp(windowSize.height));
    const width = shortSideVp * DetailResponsiveLayoutUtil.IMAGE_SHORT_SIDE_RATIO;
    const height = width * DetailResponsiveLayoutUtil.IMAGE_ASPECT_HEIGHT /
      DetailResponsiveLayoutUtil.IMAGE_ASPECT_WIDTH;
    return { width, height };
  }

  /** 左右布局文本区宽度（长边 40%） */
  static getTextAreaWidth(windowSize: window.Size): number {
    const longSideVp = Math.max(
      DetailResponsiveLayoutUtil.pxToVp(windowSize.width),
      DetailResponsiveLayoutUtil.pxToVp(windowSize.height));
    return longSideVp * DetailResponsiveLayoutUtil.TEXT_LONG_SIDE_RATIO;
  }
}
