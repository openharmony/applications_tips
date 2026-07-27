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
import { AbilityConstant, Configuration, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { ContextHelper, DetailPageConstant, LanguageUtil, Logger } from '@ohos/common';
import { FormPresenter } from '@ohos/tips_form';

export default class EntryAbility extends UIAbility {
  private formId: string = '';

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    try {
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
      ContextHelper.getInstance().setContext(this.context)
      AppStorage.setOrCreate(LanguageUtil.LANGUAGE_CONFIG_KEY, this.context.config.language ?? '');
      this.parseFromParam(want);
      FormPresenter.getInstance().updateForm(this.formId);
    } catch (err) {
      Logger.error('Failed to set colorMode. Cause: %{public}s', JSON.stringify(err));
    }
    Logger.info('Ability onCreate');
  }

  onDestroy(): void {
    Logger.info('Ability onDestroy');
    this.formId = '';
  }

  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    Logger.info('Ability onNewWant');
    this.parseFromParam(want);
    FormPresenter.getInstance().updateForm(this.formId);
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    Logger.info('Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        Logger.error('Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      Logger.info('Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    Logger.info('Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    Logger.info('Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    Logger.info('Ability onBackground');
  }

  onConfigurationUpdate(newConfig: Configuration): void {
    AppStorage.setOrCreate(LanguageUtil.LANGUAGE_CONFIG_KEY, newConfig.language ?? '');
    if (this.formId) {
      FormPresenter.getInstance().refreshFormLocale(this.formId, this.context);
    }
  }

  /**
   * 解析Want参数
   * 从Want参数中提取卡片实体
   *
   * @param want Want参数对象
   */
  private parseFromParam(want: Want): void {
    const jumpParam = FormPresenter.getInstance().parseFormJumpParam(want);
    this.formId = jumpParam?.formId ?? '';
    AppStorage.setOrCreate(DetailPageConstant.DEFAULT_PAGE_STORAGE_KEY, jumpParam?.detailLink ?? '')
  }
}
