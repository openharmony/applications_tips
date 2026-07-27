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
import common from "@ohos.app.ability.common";

/**
 * 上下文帮助类
 */
export class ContextHelper {
  private context?: common.Context;
  private static instance: ContextHelper;

  private constructor() {
  }

  /**
   * 获取单例实例
   *
   * @returns 单例实例
   */
  public static getInstance() {
    if (!ContextHelper.instance) {
      ContextHelper.instance = new ContextHelper();
    }
    return ContextHelper.instance;
  }

  /**
   * 获取上下文
   *
   * @returns 上下文
   */
  public getContext(): common.Context | undefined {
    return this.context;
  }

  /**
   * 设置上下文
   *
   * @param context 上下文
   */
  public setContext(context: common.Context) {
    this.context = context;
  }
}