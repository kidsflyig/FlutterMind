import 'package:FlutterMind/MapController.dart';
import 'package:FlutterMind/Settings.dart';
import 'package:FlutterMind/Style.dart';
import 'package:FlutterMind/dialogs/ColorPickerDialog.dart';
import 'package:FlutterMind/third_party/smartselection/smart_select.dart';
import 'package:FlutterMind/utils/localization.dart';
import 'package:FlutterMind/widgets/NodeWidgetBase.dart';
import 'package:flutter/material.dart';
// import 'package:smart_select/smart_select.dart';
// import 'choices.dart' as choices;

List<S2Choice<double>> font_sizes = [
  S2Choice<double>(value: 12, title: '12'),
  S2Choice<double>(value: 13, title: '13'),
  S2Choice<double>(value: 14, title: '14'),
  S2Choice<double>(value: 15, title: '15'),
  S2Choice<double>(value: 16, title: '16'),
  S2Choice<double>(value: 17, title: '17'),
  S2Choice<double>(value: 18, title: '18'),
];

List<S2Choice<bool>> is_font_bold = [
  S2Choice<bool>(value: false, title: 'normal'),
  S2Choice<bool>(value: true, title: 'bold')
];

List<S2Choice<String>> font_families = [
  S2Choice<String>(value: 'BERNHC', title: 'BERNHC'),
];

class StyleEditorDialog extends StatefulWidget {
  NodeWidgetBase widget;

  StyleEditorDialog(this.widget);

  static Future show(BuildContext ctx, selected) async {
    var result = await showDialog(
        context: ctx,
        builder: (context) {
          return AlertDialog(
                      title: Text("编辑样式"),
                      content: StyleEditorDialog(selected)
                      );
        });

    return result;
  }

  @override
  _StyleEditorDialogState createState() => _StyleEditorDialogState();
}

class _StyleEditorDialogState extends State<StyleEditorDialog> {
  double font_size = 12;
  bool is_bold = false;
  String family = "";
  Color _bgColor;
  Color _nodeBgColor;
  Color _edgeColor;
  int _template = 0;

  _StyleEditorDialogState() {

  }

  @override
  Widget build(BuildContext context) {
    // global
    _bgColor = Settings().backgroundColor;
    _edgeColor = Settings().edgeColor;

    // node
    Style style = Style.styleForWidget(widget.widget);
    _nodeBgColor = style.bgColor();
    font_size = style.fontSize();
    is_bold = style.fontIsBold();

    return Column(
      children: <Widget>[
        const SizedBox(height: 7),
        SmartSelect<int>.single(
          title: FMLocalizations.of(context).template,
          selectedValue: _template,
          choiceItems: Style.choices(),
          modalType: S2ModalType.popupDialog,
          modalFooterBuilder: (BuildContext context, S2SingleState<int> state) {
            return GestureDetector(
              child:Container(width:100, height:100, color:Colors.red,
            child: Text(state.selected.toString())),
            onTap:() {
              // state.showModal();
            }
            );
          },
          onChange: (selected) {
            // MapController().setFontSize(font_size, widget.widget);
          }
        ),
        const Divider(indent: 0, thickness: 2),
        SmartSelect<double>.single(
          title: FMLocalizations.of(context).font_size,
          selectedValue: font_size,
          choiceItems: font_sizes,
          modalType: S2ModalType.popupDialog,
          onChange: (selected) {
            setState(() => font_size = selected.value);
            MapController().setFontSize(font_size, widget.widget);
          }
        ),
        const Divider(indent: 20),
        SmartSelect<bool>.single(
          title: '粗体',
          selectedValue: is_bold,
          choiceItems: is_font_bold,
          modalType: S2ModalType.popupDialog,
          onChange: (selected) {
            setState(() => is_bold = selected.value);
            MapController().setFontWeight(is_bold, widget.widget);
          }
        ),
        const Divider(indent: 20),
        SmartSelect<String>.single(
          title: '字体',
          selectedValue: family,
          choiceItems: font_families,
          modalType: S2ModalType.popupDialog,
          onChange: (selected) {
            setState(() => family = selected.value);
            MapController().setFontFamily(family, widget.widget);
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
              MapController().setBackgroundColorForWidget(c, widget.widget);
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
        const Divider(indent: 20),
        IconButton(
          onPressed: () {
            MapController().saveAsTemplate(widget.widget);
            setState((){});
          }, icon: Icon(Icons.star)),
        const SizedBox(height: 7),
      ],
    );
  }
}
