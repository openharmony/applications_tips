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
import formInfo from '@ohos.app.form.formInfo';

export class FormParam {
  public formId: string = '';
  public dimension: formInfo.FormDimension = formInfo.FormDimension.Dimension_2_2;
  public name: string = '';
  public moduleName: string = '';
  public width: number = 0;
  public height: number = 0;
  public isTemporary: boolean = false;
  public bundleName: string = '';
  public abilityName: string = '';
  public deviceId: string = '';
  public extraParams: Record<string, string> = {};
}
