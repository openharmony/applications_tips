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
import { TipsConvert } from "../convert/TipsConvert";
import { DetailPageConstant, ContextHelper, Logger, RawFileResourceUtil } from "@ohos/common";
import { TipsEntity } from "../entity/TipsEntity";
import formBindingData from "@ohos.app.form.formBindingData";
import formProvider from "@ohos.app.form.formProvider";
import { FormParam } from "../model/FormParam";
import { Want } from "@kit.AbilityKit";
import formInfo from "@ohos.app.form.formInfo";
import { FormJumpParam } from '../model/FormJumpParam';

/**
 * 卡片Presenter
 */
export class FormPresenter {
  private static instance: FormPresenter;
  private tipIds: string[] = [];
  private tipsCount: number = 0;
  private currentIndex: number = 0;
  private formTipIndexMap: Map<string, number> = new Map();

  private constructor() {}

  /**
   * 获取单例实例
   *
   * @returns 单例实例
   */
  public static getInstance() {
    if (!FormPresenter.instance) {
      FormPresenter.instance = new FormPresenter();
    }
    return FormPresenter.instance;
  }

  /**
   * 按需加载卡片 ID 列表
   * @param context 可选，FormExtensionAbility 进程必须传入
   * @returns 是否加载成功
   */
  private ensureInit(context?: common.Context): boolean {
    if (this.tipsCount > 0) {
      return true;
    }
    Logger.info('init tips list');
    // 优先使用调用方传入的 context，解决 Form 进程与 UIAbility 进程 Context 隔离问题
    const ctx = context ?? ContextHelper.getInstance().getContext();
    if (!ctx) {
      return false;
    }
    try {
      const tipIds: string[] | undefined =
        RawFileResourceUtil.readJsonSync<string[]>(ctx, DetailPageConstant.TIPS_LIST_JSON);
      if (!tipIds || tipIds.length === 0) {
        throw new Error('tips_list.json is empty');
      }
      this.tipIds = tipIds;
      this.tipsCount = this.tipIds.length;
      Logger.info(`init tips list, count: ${this.tipsCount}`);
      return true;
    } catch (err) {
      Logger.error('Failed to init tips list. Cause: %{public}s', JSON.stringify(err));
      return false;
    }
  }

  /**
   * 按唯一编号加载卡片 JSON
   *
   * @param tipId 卡片唯一编号，对应 rawfile 子目录名
   * @param context 上下文
   */
  private loadTipEntity(tipId: string, context: common.Context): TipsEntity | undefined {
    const rawFilePath = `${tipId}/${DetailPageConstant.TIP_JSON}`;
    return RawFileResourceUtil.readJsonSync<TipsEntity>(context, rawFilePath);
  }
  /**
   * 更新卡片
   * 从卡片列表中获取下一个卡片实体，更新卡片内容
   *
   * @param formId 卡片ID
   */
  public updateForm(formId: string): void {
    Logger.info('updateForm, formId: %{public}s', formId);
    if (!formId) {
      return;
    }
    const ctx = ContextHelper.getInstance().getContext();
    if (!ctx || !this.ensureInit(ctx)) {
      return;
    }
    let nextIndex = (this.currentIndex + 1) % this.tipsCount;
    let tipId = this.tipIds[nextIndex];
    let nextTip = this.loadTipEntity(tipId, ctx);
    if (!nextTip) {
      return;
    }
    let model = TipsConvert.entityToModel(nextTip, ctx);
    model.formId = formId;
    this.formTipIndexMap.set(formId, nextIndex);
    let formInfo = formBindingData.createFormBindingData(model);
    formProvider.updateForm(formId, formInfo).then(() => {
      this.currentIndex = nextIndex;
    })
  }

  /**
   * 定时随机刷新卡片
   * @param formId 卡片ID
   * @param context FormExtensionAbility 上下文，Form 进程内 ContextHelper 不可用
   */
  public randomRefreshForm(formId: string, context: common.Context): void {
    if (!formId) {
      return;
    }
    if (!this.ensureInit(context)) {
      return;
    }
    let randomIndex = Math.floor(Math.random() * this.tipsCount);
    let tipId = this.tipIds[randomIndex];
    let tip = this.loadTipEntity(tipId, context);
    if (!tip) {
      return;
    }
    let model = TipsConvert.entityToModel(tip, context);
    model.formId = formId;
    this.formTipIndexMap.set(formId, randomIndex);
    let formInfo = formBindingData.createFormBindingData(model);
    formProvider.updateForm(formId, formInfo).then(() => {
      Logger.info(`randomRefreshForm success, index: ${randomIndex}`);
    })
  }

  /**
   * 添加卡片
   * 从卡片列表中获取第一个卡片实体，添加卡片内容
   *
   * @param formId 卡片ID
   * @param context 可选(onAddForm 在 Form 进程执行，需传入 FormExtensionAbility.this.context)
   */
  public addForm(formId: string, context?: common.Context): void {
    const ctx = context ?? ContextHelper.getInstance().getContext();
    if (!ctx || !this.ensureInit(ctx)) {
      return;
    }
    let tipId = this.tipIds[0];
    let tip = this.loadTipEntity(tipId, ctx);
    if (!tip) {
      return;
    }
    let model = TipsConvert.entityToModel(tip, ctx);
    model.formId = formId;
    this.formTipIndexMap.set(formId, 0);
    let formInfo = formBindingData.createFormBindingData(model);
    formProvider.updateForm(formId, formInfo).then(() => {
      this.currentIndex++;
    })
  }

  /**
   * 系统语言变更后刷新卡片，触发 $r 文案与绑定数据重新解析
   */
  public refreshFormLocale(formId: string, context?: common.Context): void {
    if (!formId) {
      return;
    }
    const ctx = context ?? ContextHelper.getInstance().getContext();
    if (!ctx || !this.ensureInit(ctx)) {
      return;
    }
    const index = this.formTipIndexMap.get(formId) ?? 0;
    const tipId = this.tipIds[index % this.tipsCount];
    const tip = this.loadTipEntity(tipId, ctx);
    if (!tip) {
      return;
    }
    const model = TipsConvert.entityToModel(tip, ctx);
    model.formId = formId;
    const formInfo = formBindingData.createFormBindingData(model);
    formProvider.updateForm(formId, formInfo);
  }

  /**
   * 解析Want参数
   * 从Want参数中提取卡片实体
   *
   * @param want Want参数对象
   * @returns 卡片实体
   */
  public parseFormParam(want: Want): FormParam {
    let formParam = new FormParam();

    if (!want || !want.parameters) {
      return formParam;
    }

    try {
      let wantParams: Record<string, Object> = want.parameters as Record<string, Object>;
      formParam.formId = wantParams[formInfo.FormParam.IDENTITY_KEY] as string;
      formParam.dimension = wantParams[formInfo.FormParam.DIMENSION_KEY] as formInfo.FormDimension;
      formParam.name = wantParams[formInfo.FormParam.NAME_KEY] as string;
      formParam.moduleName = wantParams[formInfo.FormParam.MODULE_NAME_KEY] as string;
      formParam.width = wantParams[formInfo.FormParam.WIDTH_KEY] as number;
      formParam.height = wantParams[formInfo.FormParam.HEIGHT_KEY] as number;
      formParam.isTemporary = wantParams[formInfo.FormParam.TEMPORARY_KEY] as boolean;
      formParam.bundleName = wantParams[formInfo.FormParam.BUNDLE_NAME_KEY] as string;
      formParam.abilityName = wantParams[formInfo.FormParam.ABILITY_NAME_KEY] as string;
      return formParam
    } catch (error) {
      Logger.error('Failed to parse form param. Cause: %{public}d', error.code);
      return new FormParam();
    }
  }

  /**
   * 解析Want参数
   * 从Want参数中提取卡片跳转实体
   *
   * @param want Want参数对象
   * @returns 卡片跳转实体
   */
  public parseFormJumpParam(want: Want): FormJumpParam | undefined {
    let paramStr = want.parameters?.params as string;
    if (!paramStr) {
      return undefined;
    }
    let param = JSON.parse(paramStr) as FormJumpParam;
    if (!param.formId) {
      param.formId = (want.parameters?.formID)?.toString() ?? ''
    }
    return param;
  }
}
