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
import { TipsEntity } from "../entity/TipsEntity";
import { TipModel } from "../model/TipModel";
import { ContextHelper, Logger, RawFileResourceUtil } from '@ohos/common';

/**
 * 卡片转换类
 */
export class TipsConvert {
  /**
   * 卡片实体转换为卡片模型
   *
   * @param entity 卡片实体
   * @param context 可选，Form 进程调用时需传入 FormExtensionAbility.this.context；
   *                未传入时回退 ContextHelper（EntryAbility 点击路径）
   * @returns 卡片模型
   */
  static entityToModel(entity: TipsEntity, context?: common.Context): TipModel {
    const model: TipModel = new TipModel();
    const ctx = context ?? ContextHelper.getInstance().getContext();
    try {
      model.tipDescZh = entity.tipDesc.zh;
      model.tipDescEn = entity.tipDesc.en || entity.tipDesc.zh;
      if (ctx) {
        model.tipBgImage = RawFileResourceUtil.getImageBase64Sync(ctx, entity.detailLink, entity.tipBgImage);
      }
      model.detailLink = entity.detailLink;
    } catch (error) {
      Logger.error(`TipsConvert entityToModel error: ${error}`)
    }

    return model;
  }
}
