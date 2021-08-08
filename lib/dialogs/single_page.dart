import 'package:FlutterMind/MapController.dart';
import 'package:FlutterMind/Settings.dart';
import 'package:FlutterMind/dialogs/ColorPickerDialog.dart';
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
  Color _bgColor;
  Color _nodeBgColor;
  Color _edgeColor;

  _FeaturesSinglePageState() {
    _bgColor = Settings().backgroundColor;
    _nodeBgColor = Settings().nodeBgColor;
    _edgeColor = Settings().edgeColor;
  }

  @override
  Widget build(BuildContext context) {
    font_size = Settings().fontSize;
    is_bold = Settings().fontWeight;

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
        const Divider(indent: 5),
        GestureDetector(
          child: Row(children: [
            Text("Background Color"),
            Container(
              width:10,
              height:10,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),//边框
                borderRadius: BorderRadius.all(Radius.circular(1.0)),
                color: _bgColor,
              ),
            ),
          ],),
          onTap: () {
            ColorPickerDialog.show(context, (Color c) {
              MapController().setBackgroundColor(c);
              setState((){
                _bgColor = c;
              });
            }, _bgColor);
          },
        ),
        const Divider(indent: 20),
        GestureDetector(
          child: Row(children: [
            Text("Node Color"),
            Container(
              width:10,
              height:10,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),//边框
                borderRadius: BorderRadius.all(Radius.circular(1.0)),
                color: _nodeBgColor,
              ),
            ),
          ],),
          onTap: () {
            ColorPickerDialog.show(context, (Color c) {
              MapController().setNodeBackgroundColor(c);
              setState((){
                _nodeBgColor = c;
              });
            }, _nodeBgColor);
          },
        ),
        const Divider(indent: 20),
        GestureDetector(
          child: Row(children: [
            Text("Edge Color"),
            Container(
              width:10,
              height:10,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),//边框
                borderRadius: BorderRadius.all(Radius.circular(1.0)),
                color: _edgeColor,
              ),
            ),
          ],),
          onTap: () {
            ColorPickerDialog.show(context, (Color c) {
              MapController().setEdgeColor(c);
              setState((){
                _edgeColor = c;
              });
            }, _edgeColor);
          },
        ),
        const SizedBox(height: 7),
      ],
    );
  }
}
