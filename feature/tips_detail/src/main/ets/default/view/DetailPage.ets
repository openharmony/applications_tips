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
import { DetailPageConvert } from '../convert/DetailPageConvert';
import { DetailPageConstant, LanguageUtil, Logger, WindowInfo } from '@ohos/common';
import { DetailImageSize, DetailResponsiveLayoutUtil } from '../util/DetailResponsiveLayoutUtil';
import EnvironmentProp from '../common/EnvironmentProp';


@Component
export struct DetailPage {
  @Watch('onDetailPageLinkChange')
  @StorageProp(DetailPageConstant.DEFAULT_PAGE_STORAGE_KEY) detailLink: string = DetailPageConstant.DEFAULT_PAGE_ID;
  @StorageProp(LanguageUtil.LANGUAGE_CONFIG_KEY) @Watch('onLanguageConfigChange') languageConfig: string = '';
  @StorageLink('mainWindowInfo') @Watch('onWindowInfoChange') windowInfo: WindowInfo = new WindowInfo();
  @State detailImage: string = '';
  @State detailTitle: string = '';
  @State detailText: string = '';
  @State isSideBySide: boolean = false;
  @State imageSize: DetailImageSize = { width: 0, height: 0 };
  @State TextSize: number = 0;

  aboutToAppear(): void {
    this.loadDetailContent();
  }

  build() {
    NavDestination() {
      Column() {
        if (EnvironmentProp.isPad()) {
          this.PadDetailContent()
        } else {
          this.PhoneDetailContent()
        }
      }
      .width('100%')
      .height('100%')
      .alignItems(HorizontalAlign.Start)
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
      .onAppear(()=>{
        this.updateResponsiveLayout()
      })
    }
  }

  /** phone-上下布局 */
  @Builder
  PhoneDetailContent() {
    Scroll(){
      Column() {
        Image(this.detailImage)
          .width('100%')
          .height('56%')
          .objectFit(ImageFit.Cover)
          .interpolation(ImageInterpolation.Low)
          .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])

        Row(){
          this.DetailTextBlock(20, 14, 22, TextAlign.Start)
        }
        .width('100%')
        .padding({
          top:20,
          left: DetailResponsiveLayoutUtil.TEXT_MARGIN_2M,
          right: DetailResponsiveLayoutUtil.TEXT_MARGIN_2M
        })
      }
    }
    .height('100%')
    .width('100%')
    .align(Alignment.Top)
    .scrollBar(BarState.Off)
    .edgeEffect(EdgeEffect.Spring)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }

  /** pad-上下布局/左右布局 */
  @Builder
  PadDetailContent() {
    if (this.isSideBySide) {
      this.PadSideBySideLayout()
    } else {
      this.PadStackedLayout()
    }
  }

  /** Pad 左右布局*/
  @Builder
  PadSideBySideLayout() {
    Row(){
      this.DetailImageBlock(ItemAlign.Center)
      Scroll(){
        this.DetailTextBlock(24, 16, 24, TextAlign.Start)
      }
      .width(this.TextSize > 0 ? this.TextSize : '40%')
      .height('100%')
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
      .padding({
        left: DetailResponsiveLayoutUtil.TEXT_MARGIN_2M,
        right: DetailResponsiveLayoutUtil.TEXT_MARGIN_2M })
    }
    .width('100%')
    .height('100%')
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }

  /** Pad 上下布局 */
  @Builder
  PadStackedLayout() {
    Scroll(){
      Column(){
        this.DetailImageBlock(ItemAlign.Center)
        Row(){
          this.DetailTextBlock(24, 16, 24, TextAlign.Start)
        }
        .padding({
          top: 20,
          left: DetailResponsiveLayoutUtil.TEXT_MARGIN_2M,
          right: DetailResponsiveLayoutUtil.TEXT_MARGIN_2M })
      }
    }
    .scrollBar(BarState.Off)
    .edgeEffect(EdgeEffect.Spring)
    .width('100%')
    .height('100%')
    .align(Alignment.Top)
    .padding({ top: 20 })
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }

  /** 图片比例为 4:3 且 宽度=屏幕短边×80% */
  @Builder
  DetailImageBlock(align: ItemAlign) {
    Image(this.detailImage)
      .width(this.imageSize.width > 0 ? this.imageSize.width : '80%')
      .aspectRatio(DetailResponsiveLayoutUtil.IMAGE_ASPECT_WIDTH /
        DetailResponsiveLayoutUtil.IMAGE_ASPECT_HEIGHT)
      .objectFit(ImageFit.Cover)
      .interpolation(ImageInterpolation.Low)
      .borderRadius(15)
  }

  @Builder
  DetailTextBlock(titleSize: number, bodySize: number, lineHeight: number, align: TextAlign) {
    Column() {
      Text(this.detailTitle)
          .fontSize(titleSize)
          .fontWeight(FontWeight.Bold)
          .textAlign(align)
          .margin({ bottom: 12 })

      Text(this.detailText)
        .fontSize(bodySize)
        .fontWeight(FontWeight.Regular)
        .lineHeight(lineHeight)
        .textAlign(align)
    }
    .width('100%')
  }

  onWindowInfoChange(): void {
    if (EnvironmentProp.isPad()) {
      this.updateResponsiveLayout();
    }
  }

  onDetailPageLinkChange(): void {
    this.loadDetailContent();
  }

  onLanguageConfigChange(): void {
    this.loadDetailContent();
  }

  /** 更新计算布局模式与配图尺寸 */
  private updateResponsiveLayout(): void {
    this.isSideBySide = DetailResponsiveLayoutUtil.isSideBySide(
      this.windowInfo.widthBp, this.windowInfo.windowSize);
    this.imageSize = DetailResponsiveLayoutUtil.getImageSize(this.windowInfo.windowSize);
    this.TextSize = DetailResponsiveLayoutUtil.getTextAreaWidth(this.windowInfo.windowSize);
  }

  private loadDetailContent(): void {
    try {
      const context = this.getUIContext().getHostContext();
      if (!context) {
        return;
      }
      const model = DetailPageConvert.idToModel(this.detailLink, context);
      this.detailImage = model.image;
      this.detailTitle = model.title;
      this.detailText = model.text;
    } catch (err) {
      Logger.error('loadDetailContent error: ' + err);
    }
  }
}

@Builder
export function DetailPageBuilder() {
  DetailPage();
}
