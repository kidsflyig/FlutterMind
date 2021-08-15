import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
// import 'package:i18n_demo/i18n/localizations.dart';

class FMLocalizations {
  final Locale locale;

  FMLocalizations(this.locale);

  static FMLocalizations of(BuildContext context) {
    return Localizations.of(context, FMLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    "en": {
      "font_size": "Font Size",
      "tempate": "Style Template",
    },
    "zh": {
      "font_size": "字体大小",
      "tempate": "样式模板",
    }
  };

  String get font_size {
    return _localizedValues[locale.languageCode]["font_size"];
  }

  String get template {
    return _localizedValues[locale.languageCode]["tempate"];
  }
}



class FMLocalizationsDelegate extends LocalizationsDelegate<FMLocalizations> {
  @override
  bool isSupported(Locale locale) {
    return ["en", "zh"].contains(locale.languageCode);
  }

  @override
  bool shouldReload(LocalizationsDelegate<FMLocalizations> old) {
    return false;
  }

  @override
  Future<FMLocalizations> load(Locale locale) {
    return SynchronousFuture(FMLocalizations(locale));
  }

  static FMLocalizationsDelegate delegate = FMLocalizationsDelegate();
}