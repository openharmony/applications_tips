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
import { window } from '@kit.ArkUI';
import { DetailPageConstant, Logger, WindowInfo, WindowUtil } from '@ohos/common';
import { FormJumpParam } from '@ohos/tips_form';

const DETAIL_PAGE_NAME = 'DetailPage';

@Entry
@Component
struct Index {
  @State pathStack: NavPathStack = new NavPathStack();
  @State detailPageContent: string = '';
  @State detailPageLink: string = '';
  private windowUtil?: WindowUtil;

  aboutToAppear(): void {
    const routerParam = this.getUIContext().getRouter().getParams() as FormJumpParam;
    if (routerParam) {
      this.detailPageLink = routerParam.detailLink;
    } else {
      this.detailPageLink = DetailPageConstant.DEFAULT_PAGE_ID
    }
    AppStorage.setOrCreate('mainWindowInfo', new WindowInfo());
    this.initWindowUtil();
  }

  aboutToDisappear(): void {
    this.windowUtil?.destroy();
  }

  /** 注册 windowSizeChange，同步横向/纵向断点到 AppStorage */
  private async initWindowUtil(): Promise<void> {
    try {
      const context = this.getUIContext().getHostContext();
      if (!context) {
        return;
      }
      const mainWindow = await window.getLastWindow(context);
      this.windowUtil = new WindowUtil(mainWindow);
      this.windowUtil.setUIContext();
      AppStorage.setOrCreate('mainWindowInfo', this.windowUtil.mainWindowInfo);
      this.windowUtil.updateWindowInfo();
    } catch (err) {
      Logger.error('initWindowUtil error: ' + JSON.stringify(err));
    }
  }

  build() {
    Navigation(this.pathStack) {

    }
    .id('root_navigation')
    .width('100%')
    .height('100%')
    .hideTitleBar(true)
    .hideNavBar(true)
    .mode(NavigationMode.Stack)
    .onAppear(() => {
      this.pathStack.pushPathByName(DETAIL_PAGE_NAME, null, false);
    })
    .ignoreLayoutSafeArea([LayoutSafeAreaType.SYSTEM], [LayoutSafeAreaEdge.TOP, LayoutSafeAreaEdge.BOTTOM])
  }
}
