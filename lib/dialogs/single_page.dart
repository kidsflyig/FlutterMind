import 'package:FlutterMind/MapController.dart';
import 'package:FlutterMind/Settings.dart';
import 'package:FlutterMind/third_party/smartselection/smart_select.dart';
import 'package:FlutterMind/utils/localization.dart';
import 'package:flutter/material.dart';
// import 'package:smart_select/smart_select.dart';
import 'choices.dart' as choices;

class FeaturesSinglePage extends StatefulWidget {
  @override
  _FeaturesSinglePageState createState() => _FeaturesSinglePageState();
}

class _FeaturesSinglePageState extends State<FeaturesSinglePage> {
  double font_size = 12;
  bool is_bold = false;
  String family = "";

  @override
  Widget build(BuildContext context) {
    font_size = Settings().default_font_size;
    is_bold = Settings().default_font_weight;

    return Column(
      children: <Widget>[
        const SizedBox(height: 7),
        SmartSelect<double>.single(
          title: FMLocalizations.of(context).font_size,
          selectedValue: font_size,
          choiceItems: choices.font_sizes,
          modalType: S2ModalType.popupDialog,
          onChange: (selected) {
            setState(() => font_size = selected.value);
            MapController().setDefaultFontSize(font_size);
          }
        ),
        const Divider(indent: 20),
        SmartSelect<bool>.single(
          title: '粗体',
          selectedValue: is_bold,
          choiceItems: choices.is_font_bold,
          modalType: S2ModalType.popupDialog,
          onChange: (selected) {
            setState(() => is_bold = selected.value);
            MapController().setDefaultFontWeight(is_bold);
          }
        ),
        const Divider(indent: 20),
        SmartSelect<String>.single(
          title: '字体',
          selectedValue: family,
          choiceItems: choices.font_families,
          modalType: S2ModalType.popupDialog,
          onChange: (selected) {
            setState(() => family = selected.value);
            MapController().setDefaultFontFamily(family);
          }
        ),
        const SizedBox(height: 7),
      ],
    );
  }
}
