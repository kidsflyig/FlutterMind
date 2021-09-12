import 'package:FlutterMind/MapController.dart';
import 'package:FlutterMind/Settings.dart';
import 'package:FlutterMind/StyleManager.dart';
import 'package:FlutterMind/dialogs/ColorPickerDialog.dart';
import 'package:FlutterMind/dialogs/EditingDialog.dart';
import 'package:FlutterMind/dialogs/SelectionListDialog.dart';
import 'package:FlutterMind/third_party/smartselection/smart_select.dart';
import 'package:FlutterMind/utils/Log.dart';
import 'package:FlutterMind/utils/Localization.dart';
import 'package:FlutterMind/utils/Utils.dart';
import 'package:FlutterMind/widgets/NodeWidgetBase.dart';
import 'package:flutter/material.dart';
// import 'package:smart_select/smart_select.dart';
// import 'choices.dart' as choices;
import 'package:FlutterMind/utils/Constants.dart';

import 'ScaleDialog.dart';

List<SelectionItem> font_sizes = [
  SelectionItem(value: 12, title: '12'),
  SelectionItem(value: 13, title: '13'),
  SelectionItem(value: 14, title: '14'),
  SelectionItem(value: 15, title: '15')
];

List<SelectionItem> is_font_bold = [
  SelectionItem(value: false, title: 'normal'),
  SelectionItem(value: true, title: 'bold')
];

List<SelectionItem> font_families = [
  SelectionItem(value: 'BERNHC', title: 'BERNHC'),
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
              titleTextStyle: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold, fontSize: 18,
                decorationStyle: TextDecorationStyle.wavy
              ),
              scrollable: true,
              contentPadding : const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              content: StyleEditorDialog(selected));
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
  Color _nodeBorderColor;
  int _template = 0;

  _StyleEditorDialogState() {}

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
    _nodeBorderColor = style.nodeBorderColor();

    return Container(
        width: 100,
        child: IntrinsicHeight(
            child: Column(
          children: <Widget>[
            SelectionPanel<String>(
              title: LC.getString(context, C.template),
              selectedValue: style.name(),
              choiceItems: StyleManager().choices(),
              widget: widget.widget,
              confirm: (SelectionListDialog dialog) {
                EditingDialog.showMyDialog(
                    context,
                    EditConfig(
                        pos: Utils.center(),
                        maxLength: 20,
                        maxLines: 1,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        onSubmit: (msg) {
                          MapController().saveAsTemplate(widget.widget, msg);
                          setState(() {});
                          dialog.update(StyleManager().choices(), style.name());
                        }));
              },
              onChanged: (selected) {
                Style s = StyleManager().getStyle(selected);
                NodeWidgetBase w = widget.widget;
                w.setStyle(s);
              },
            ),
            const Divider(indent: 10, thickness: 2),
            SelectionPanel<double>(
                title: LC.getString(context, C.font_size),
                selectedValue: font_size,
                choiceItems: font_sizes,
                widget: widget.widget,
                onChanged: (selected) {
                  Log.e("new font size = " + selected.toString());
                  MapController().setFontSize(selected, widget.widget);
                },
                onpressed: () {
                  ScaleDialog.show(context, 15, 30, 5, (size) {
                    MapController().setFontSize(size, widget.widget);
                  });
                }
                ),
            // const Divider(indent: 10, thickness: 2),
            SelectionPanel<bool>(
                title: LC.getString(context, C.bold),
                selectedValue: is_bold,
                choiceItems: is_font_bold,
                widget: widget.widget,
                onChanged: (selected) {
                  setState(() => is_bold = selected);
                  MapController().setFontWeight(is_bold, widget.widget);
                }),
            // const Divider(indent: 10, thickness: 2),
            SelectionPanel<String>(
                title: LC.getString(context, C.font),
                selectedValue: family,
                choiceItems: font_families,
                widget: widget.widget,
                onChanged: (selected) {
                  setState(() => family = selected);
                  MapController().setFontFamily(family, widget.widget);
                }),

            const Divider(indent: 10, thickness: 2),
            SelectionPanel<String>(
                title: LC.getString(context, C.background_color),
                selectedValue: "",
                widget: widget.widget,
                right: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1), //边框
                    borderRadius: BorderRadius.all(Radius.circular(1.0)),
                    color: _bgColor,
                  ),
                ),
                onpressed: () {
                  ColorPickerDialog.show(context, (Color c) {
                    MapController().setBackgroundColor(c);
                    setState(() {
                      _bgColor = c;
                    });
                  }, _bgColor);
                }),
            const Divider(indent: 10, thickness: 2),
            SelectionPanel<String>(
                title: LC.getString(context, C.node_color),
                selectedValue: "",
                widget: widget.widget,
                right: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1), //边框
                    borderRadius: BorderRadius.all(Radius.circular(1.0)),
                    color: _nodeBgColor,
                  ),
                ),
                onpressed: () {
                  ColorPickerDialog.show(context, (Color c) {
                    MapController()
                        .setBackgroundColorForWidget(c, widget.widget);
                    setState(() {
                      _nodeBgColor = c;
                    });
                  }, _nodeBgColor);
                }),
            SelectionPanel<String>(
                title: LC.getString(context, C.edge_color),
                selectedValue: "",
                widget: widget.widget,
                right: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1), //边框
                    borderRadius: BorderRadius.all(Radius.circular(1.0)),
                    color: _edgeColor,
                  ),
                ),
                onpressed: () {
                  ColorPickerDialog.show(context, (Color c) {
                    MapController().setEdgeColor(c);
                    setState(() {
                      _edgeColor = c;
                    });
                  }, _edgeColor);
                }),
            SelectionPanel<String>(
                title: "边框颜色",
                selectedValue: "",
                widget: widget.widget,
                right: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1), //边框
                    borderRadius: BorderRadius.all(Radius.circular(1.0)),
                    color: _nodeBorderColor,
                  ),
                ),
                onpressed: () {
                  ColorPickerDialog.show(context, (Color c) {
                    Log.e("pick new border colro " + c.toString());
                    MapController().setNodeBorderColor(c);
                    setState(() {
                      _nodeBorderColor = c;
                    });
                  }, _nodeBorderColor);
                }),
            const SizedBox(height: 7),
          ],
        )));
  }
}
