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
import { WidgetCardView } from '@ohos/tips_form/component';

/**
 * 服务卡片 Form 入口页（form_config 约束必须位于 product/entry 模块）
 * LocalStorage 绑定保留在入口页，UI 实现在 feature/tips_form
 */
@Entry
@Component
struct WidgetCard {
  @LocalStorageProp('localeTag') localeTag: string = '';
  @LocalStorageProp('tipDescZh') tipDescZh: string = '';
  @LocalStorageProp('tipDescEn') tipDescEn: string = '';
  @LocalStorageProp('detailLink') detailLink: string = '';
  @LocalStorageProp('tipBgImage') tipBgImage: string = '';
  @LocalStorageProp('formId') formId: string = '';

  build() {
    Column() {
      WidgetCardView({
        localeTag: this.localeTag,
        tipDescZh: this.tipDescZh,
        tipDescEn: this.tipDescEn,
        detailLink: this.detailLink,
        tipBgImage: this.tipBgImage,
        formId: this.formId,
        abilityName: 'EntryAbility',
        widgetTitle: $r('app.string.EntryFormAbility_label'),
        widgetIcon: $r('app.media.tips_icon'),
        widgetFallbackDesc: $r('app.string.widget_desc'),
      })
    }
    .width('100%')
    .height('100%')
  }
}
