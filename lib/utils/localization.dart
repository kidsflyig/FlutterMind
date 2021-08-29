import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:FlutterMind/utils/Constants.dart';

class FMLocalizationsDelegate extends LocalizationsDelegate<LC> {
  @override
  bool isSupported(Locale locale) {
    return ["en", "zh"].contains(locale.languageCode);
  }

  @override
  bool shouldReload(LocalizationsDelegate<LC> old) {
    return false;
  }

  @override
  Future<LC> load(Locale locale) {
    return SynchronousFuture(LC(locale));
  }

  static FMLocalizationsDelegate delegate = FMLocalizationsDelegate();
}

class LC {
  final Locale locale;

  LC(this.locale);

  static LC of(BuildContext context) {
    return Localizations.of(context, LC);
  }

  String _getString(int id) {
   return _localizedValues[locale.languageCode][id];
  }

  static String getString(BuildContext context, int id) {
    return of(context)._getString(id);
  }

  static Map<String, Map<int, String>> _localizedValues = {
    "en": {
      C.font_size: "Font Size",
      C.template: "Style Template",
      C.toselect: "select",
      C.save_as_tempate:"Save as Template",
    },
    "zh": {
      C.font_size : "字体大小",
      C.template : "样式模板",
      C.toselect : "待选择",
      C.save_as_tempate :"保存为模板",
      C.add_node : "新增\n节点",
      C.remove_node : "删除\n节点",
      C.cut : "移动节点",
      C.unfold : "折叠",
      C.edit_style : "编辑样式",
      C.style_selector : "样式选择",
    }
  };
}