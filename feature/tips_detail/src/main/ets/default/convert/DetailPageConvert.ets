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
import { DetailPageConstant, LanguageUtil, Logger, RawFileResourceUtil } from '@ohos/common';
import { DetailPageEntity } from '../entity/DetailPageEntity';
import { DetailPageModel } from '../model/DetailPageModel';

/**
 * 详情页 JSON 转换
 */
export class DetailPageConvert {
  /**
   * 按详情页 id 转换为展示模型
   */
  static idToModel(pageId: string, context: common.Context): DetailPageModel {
    const model: DetailPageModel = new DetailPageModel();
    const resolvedId = pageId || DetailPageConstant.DEFAULT_PAGE_ID;
    const rawFilePath = `${resolvedId}/${DetailPageConstant.DETAIL_JSON}`;
    const entity = RawFileResourceUtil.readJsonSync<DetailPageEntity>(context, rawFilePath);
    if (!entity) {
      Logger.error(`DetailPageConvert idToModel page not found: ${resolvedId}`);
      return model;
    }

    const language = LanguageUtil.getContentLanguage(context);
    if (language === LanguageUtil.LANG_EN) {
      model.title = entity.title.en || entity.title.zh;
      model.text = entity.content.en || entity.content.zh;
    } else {
      model.title = entity.title.zh;
      model.text = entity.content.zh;
    }
    model.image = RawFileResourceUtil.getImageBase64Sync(context, resolvedId, entity.image);
    return model;
  }
}
