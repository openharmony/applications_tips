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

/**
 * 系统语言解析，用于从双语 JSON 中选择展示文案
 */
export class LanguageUtil {
  public static readonly LANG_ZH: string = 'zh';
  public static readonly LANG_EN: string = 'en';
  public static readonly LANGUAGE_CONFIG_KEY: string = 'languageConfig';

  /**
   * 根据系统 locale 返回内容语言键
   * 简体中文、繁体中文（台湾/香港）、维吾尔文、藏文 → 中文内容；英语、其余小语种 → 英文内容
   */
  static getContentLanguage(context: common.Context): string {
    try {
      const locale = LanguageUtil.normalizeLocale(
        context.resourceManager.getConfigurationSync().locale ?? ''
      );
      if (LanguageUtil.isChineseContentLocale(locale)) {
        return LanguageUtil.LANG_ZH;
      }
    } catch (error) {

    }
    return LanguageUtil.LANG_EN;
  }

  /**
   * 根据 locale 标签返回内容语言键
   */
  static resolveContentLanguage(localeTag: string): string {
    const locale = LanguageUtil.normalizeLocale(localeTag);
    if (LanguageUtil.isChineseContentLocale(locale)) {
      return LanguageUtil.LANG_ZH;
    }
    return LanguageUtil.LANG_EN;
  }

  private static normalizeLocale(locale: string): string {
    return locale.toLowerCase().replace(/-/g, '_');
  }

  private static isChineseContentLocale(locale: string): boolean {
    return locale.startsWith('zh') || locale.startsWith('ug') || locale.startsWith('bo');
  }
}
