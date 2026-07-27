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
import common from '@ohos.app.ability.common';
import { util } from '@kit.ArkTS';
import Logger from '../util/Logger';
import { StringUtil } from '../util/StringUtil';

/**
 * rawfile 资源读取工具
 */
export class RawFileResourceUtil {
  /**
   * 读取 rawfile 下指定目录中的图片并转为 Base64 data URI
   *
   * @param context 上下文
   * @param folderId 页面唯一编号，对应 rawfile 子目录名
   * @param fileName 图片文件名（含后缀）
   */
  static getImageBase64Sync(context: common.Context, folderId: string, fileName: string): string {
    if (!folderId || !fileName) {
      return '';
    }
    try {
      const rawFilePath = `${folderId}/${fileName}`;
      const contentArray = context.resourceManager.getRawFileContentSync(rawFilePath);
      if (!contentArray || contentArray.length === 0) {
        return '';
      }
      const base64Helper = new util.Base64Helper();
      const base64 = base64Helper.encodeToStringSync(contentArray);
      const mimeType = RawFileResourceUtil.getImageMimeType(fileName);
      return `data:${mimeType};base64,${base64}`;
    } catch (error) {
      Logger.error(`RawFileResourceUtil getImageBase64Sync error: ${error}`);
      return '';
    }
  }

  private static getImageMimeType(fileName: string): string {
    const dotIndex = fileName.lastIndexOf('.');
    if (dotIndex < 0) {
      return 'image/png';
    }
    const ext = fileName.substring(dotIndex + 1).toLowerCase();
    if (ext === 'jpg' || ext === 'jpeg') {
      return 'image/jpeg';
    }
    if (ext === 'bmp') {
      return 'image/bmp';
    }
    if (ext === 'webp') {
      return 'image/webp';
    }
    return 'image/png';
  }

  /**
   * 读取 rawfile JSON 文件
   *
   * @param context 上下文
   * @param rawFilePath rawfile 相对路径
   */
  static readJsonSync<T>(context: common.Context, rawFilePath: string): T | undefined {
    try {
      const contentArray = context.resourceManager.getRawFileContentSync(rawFilePath);
      if (!contentArray || contentArray.length === 0) {
        throw new Error(`${rawFilePath} is empty`);
      }
      const jsonStr = StringUtil.uint8ArrayToString(contentArray);
      return JSON.parse(jsonStr) as T;
    } catch (error) {
      Logger.error(`RawFileResourceUtil readJsonSync error: ${error}`);
      return undefined;
    }
  }
}
