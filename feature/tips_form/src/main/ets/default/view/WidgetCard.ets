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
import { i18n } from '@kit.LocalizationKit';
import { LanguageUtil } from '@ohos/common';

@Component
export struct WidgetCardView {
  readonly actionType: string = 'router';
  @Prop abilityName: string = '';
  @Prop localeTag: string = '';
  @Prop tipDescZh: string = '';
  @Prop tipDescEn: string = '';
  @Prop detailLink: string = '';
  @Prop tipBgImage: string = '';
  @Prop formId: string = '';
  @Prop widgetTitle: ResourceStr = '';
  @Prop widgetIcon: ResourceStr = '';
  @Prop widgetFallbackDesc: ResourceStr = '';

  build() {
    FormLink({
      action: this.actionType,
      abilityName: this.abilityName,
      params: {
        formId: this.formId,
        detailLink: this.detailLink,
      }
    }) {
      Stack() {
        this.backgroundBuilder()
        Column() {
          this.widgetInfoBuilder()
          Blank().layoutWeight(1).width('100%')
          this.tipsInfoBuilder()
        }
        .linearGradient({
          direction: GradientDirection.Bottom,
          colors: [['rgba(0,0,0,0)', 0.0], ['rgba(0,0,0,0.35)', 1.0]]
        })
        .padding(12)
        .alignItems(HorizontalAlign.Start)
      }
      .height('100%')
      .backgroundColor($r('sys.color.comp_background_primary'))
    }
  }

  @Builder
  backgroundBuilder() {
    Image(this.tipBgImage)
      .width('100%')
      .height('100%')
      .objectFit(ImageFit.Cover)
      .interpolation(ImageInterpolation.Low)
      .autoResize(false)
  }

  @Builder
  widgetInfoBuilder() {
    Row() {
      Text(this.widgetTitle)
        .fontSize($r('sys.float.ohos_id_text_size_headline9'))
        .fontWeight(FontWeight.Bold)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .fontColor($r('sys.color.ohos_fa_text_primary_dark'))
        .layoutWeight(1)
      Image(this.widgetIcon)
        .width(20)
        .aspectRatio(1)
    }.justifyContent(FlexAlign.SpaceBetween)
    .width('100%')
  }

  private getDisplayTipDesc(): string {
    const language = LanguageUtil.resolveContentLanguage(
      this.localeTag || i18n.System.getSystemLanguage());
    if (language === LanguageUtil.LANG_EN) {
      return this.tipDescEn || this.tipDescZh;
    }
    return this.tipDescZh;
  }

  @Builder
  tipsInfoBuilder() {
    Row() {
      Text(this.getDisplayTipDesc() || this.widgetFallbackDesc)
      .fontSize($r('sys.float.ohos_id_text_size_body2'))
      .fontWeight(FontWeight.Medium)
      .maxLines(3)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .fontColor($r('sys.color.ohos_fa_text_primary_dark'))
    }
  }
}
