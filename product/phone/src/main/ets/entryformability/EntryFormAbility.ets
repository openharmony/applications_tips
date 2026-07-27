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
import { Configuration } from '@ohos.app.ability.Configuration';
import { formBindingData, FormExtensionAbility, formInfo } from '@kit.FormKit';
import Want from '@ohos.app.ability.Want';
import { FormPresenter } from '@ohos/tips_form';
import { Logger } from '@ohos/common';


export default class EntryFormAbility extends FormExtensionAbility {
  private formIds: Set<string> = new Set();
  private pendingFirstUpdateIds: Set<string> = new Set();

  onAddForm(want: Want): formBindingData.FormBindingData {
    Logger.info('EntryFormAbility onAddForm');
    const formInfo = FormPresenter.getInstance().parseFormParam(want);
    // onAddForm 在 apppool 进程执行，ContextHelper 未设置，需传入 this.context 加载资源
    FormPresenter.getInstance().addForm(formInfo.formId, this.context);
    this.formIds.add(formInfo.formId);
    this.pendingFirstUpdateIds.add(formInfo.formId);
    return formBindingData.createFormBindingData(formInfo)
  }

  onCastToNormalForm(formId: string): void {
    Logger.info('EntryFormAbility onCastToNormalForm');
  }

  onUpdateForm(formId: string, wantParams?: Record<string, Object>): void {
    Logger.info('EntryFormAbility onUpdateForm');
    if (this.pendingFirstUpdateIds.delete(formId)) {
      return;
    }
    FormPresenter.getInstance().randomRefreshForm(formId, this.context);
  }

  onFormEvent(formId: string, message: string): void {
    Logger.info('EntryFormAbility onFormEvent');
  }

  onRemoveForm(formId: string): void {
    Logger.info('EntryFormAbility onRemoveForm');
    this.formIds.delete(formId);
    this.pendingFirstUpdateIds.delete(formId);
  }

  onConfigurationUpdate(newConfig: Configuration): void {
    Logger.info('EntryFormAbility onConfigurationUpdate, language: %{public}s', newConfig.language ?? '');
    this.formIds.forEach((formId: string) => {
      FormPresenter.getInstance().refreshFormLocale(formId, this.context);
    });
  }

  onAcquireFormState(want: Want): formInfo.FormState {
    Logger.info('EntryFormAbility onAcquireFormState');
    return formInfo.FormState.READY;
  }
}
