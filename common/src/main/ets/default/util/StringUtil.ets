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
import util from "@ohos.util";

/**
 * 字符串帮助类
 */
export class StringUtil {
  public static isEmpty(str: string): boolean {
    return str === null || str === '';
  }

  /**
   * 将Uint8Array转换为字符串
   *
   * @param uint8Array Uint8Array
   * @returns 字符串
   */
  public static uint8ArrayToString(uint8Array: Uint8Array): string {
    let textDecoderOptions: util.TextDecoderOptions = {
      fatal: false,
      ignoreBOM: true
    };
    let decodeToStringOptions: util.DecodeToStringOptions = {
      stream: false
    };
    let textDecoder = util.TextDecoder.create('utf-8', textDecoderOptions);
    let retStr = textDecoder.decodeToString(uint8Array, decodeToStringOptions);
    return retStr;
  }
}
