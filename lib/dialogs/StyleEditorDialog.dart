import 'dart:convert';

import 'package:FlutterMind/MapController.dart';
import 'package:FlutterMind/Settings.dart';
import 'package:FlutterMind/StyleManager.dart';
import 'package:FlutterMind/dialogs/ColorPickerDialog.dart';
import 'package:FlutterMind/dialogs/EditingDialog.dart';
import 'package:FlutterMind/dialogs/SelectionListDialog.dart';
import 'package:FlutterMind/third_party/dotted_border/dotted_border.dart';
import 'package:FlutterMind/third_party/smartselection/smart_select.dart';
import 'package:FlutterMind/utils/Log.dart';
import 'package:FlutterMind/utils/Localization.dart';
import 'package:FlutterMind/utils/Utils.dart';
import 'package:FlutterMind/widgets/NodeWidgetBase.dart';
import 'package:flutter/cupertino.dart';
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

List<SelectionItem> line_style = [
  SelectionItem(value: 1, title: 'Style1'),
  SelectionItem(value: 2, title: 'Style2'),
  SelectionItem(value: 3, title: 'Style3'),
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
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  decorationStyle: TextDecorationStyle.wavy),
              scrollable: true,
              contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
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
  bool italic = false;
  bool underline = false;
  String family = "";
  Color _bgColor;
  Color _nodeBgColor;
  Color _edgeColor;
  Color _nodeBorderColor;
  int _template = 0;
  int border_style = 0;
  TextAlign align = TextAlign.left;

  _StyleEditorDialogState() {}

  DottedBorder borderStyle(int index) {
    List<double> pattern = [8, 4];
    double width = 1;
    if (index == 0) {
      pattern = [8, 3];
      width = 2;
    } else {
      pattern = [8, 2];
      width = 3;
    }
    return DottedBorder(
        color: Colors.black,
        bgcolor: Colors.transparent,
        dashPattern: pattern,
        strokeWidth: width,
        strokeCap: StrokeCap.round,
        borderType: BorderType.Rect,
        radius: Radius.circular(2));
  }

  @override
  Widget build(BuildContext context) {
    // global
    _bgColor = Settings().backgroundColor;
    _edgeColor = Settings().edgeColor;

    // node
    Style style = Style.styleForWidget(widget.widget, false);
    _nodeBgColor = style.bgColor();
    font_size = style.fontSize().round().toDouble();
    is_bold = style.fontIsBold();
    italic = style.fontIsItalic();
    underline = style.fontHasUnderline();
    _nodeBorderColor = style.nodeBorderColor();
    align = style.textAlign();
    List<SelectionItem> styles = StyleManager().choices();

    Log.e("font size = " + font_size.toString());
    return Container(
        width: 120,
        child: IntrinsicHeight(
            child: Column(
          children: <Widget>[
            SelectionPanel<String>(
              title: LC.getString(context, C.template),
              selectedValue: style.name(),
              items: styles,
              bottom: IconButton(
                icon: Icon(Icons.add_circle),
              ),
              itemBuilder: (index, cur) {
                if (index < styles.length) {
                  return Text(styles[index].title);
                }
                return SizedBox(height: 1);
              },
              bottomOnPressed: () {
                //SelectionListDialog dialog) {

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
                        }));
              },
              onChanged: (i) {
                Log.e("style onchanged " + i.toString());
                Style s = StyleManager().getStyle(styles[i].value);
                NodeWidgetBase w = widget.widget;
                w.setStyle(s);
              },
            ),
            const Divider(indent: 10, thickness: 2),
            SelectionPanel<double>(
                title: LC.getString(context, C.font_size),
                selectedValue: font_size,
                items: font_sizes,
                //widget: widget.widget,
                onpressed: () {
                  ScaleDialog.show(context, 15, 30, 5, (size) {
                    Log.e("new font size = " + size.toString());
                    MapController().setFontSize(size, widget.widget);
                    font_size = size;
                    setState(() {});
                  });
                }),
            const Divider(indent: 10, thickness: 2),
            SelectionPanel<bool>(
              title: "文字格式",
              //widget: widget.widget,
              onpressed: () {},
              right: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                IconButton(
                  constraints: BoxConstraints.expand(width: 18, height: 18),
                    iconSize: 18,
                    color: is_bold ? Colors.black87 : Colors.black26,
                    padding: const EdgeInsets.all(0),
                    onPressed: () {
                      MapController().setFontWeight(!is_bold, widget.widget);
                      setState(() {});
                    },
                    icon: Icon(Icons.format_bold)),
                IconButton(
                  constraints: BoxConstraints.expand(width: 18, height: 18),
                    iconSize: 18,
                    color: italic ? Colors.black87 : Colors.black26,
                    padding: const EdgeInsets.all(0),
                    onPressed: () {
                      MapController().setFontItalic(!italic, widget.widget);
                      setState(() {});
                    },
                    icon: Icon(Icons.format_italic)),
                IconButton(
                  constraints: BoxConstraints.expand(width: 18, height: 18),
                    iconSize: 18,
                    color: underline ? Colors.black87 : Colors.black26,
                    padding: const EdgeInsets.all(0),
                    onPressed: () {
                      MapController()
                          .setFontUnderline(!underline, widget.widget);
                      setState(() {});
                    },
                    icon: Icon(Icons.format_underline)),
              ]),
            ),
            SelectionPanel<bool>(
              title: "文字对齐",
              //widget: widget.widget,
              onpressed: () {},
              right: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                IconButton(
                  constraints: BoxConstraints.expand(width: 18, height: 18),
                    iconSize: 18,
                    color: align == TextAlign.left
                        ? Colors.black87
                        : Colors.black26,
                    padding: const EdgeInsets.all(0),
                    onPressed: () {
                      MapController()
                          .setTextAlign(TextAlign.left, widget.widget);
                      setState(() {});
                    },
                    icon: Icon(Icons.format_align_left)),
                IconButton(
                  constraints: BoxConstraints.expand(width: 18, height: 18),
                    iconSize: 18,
                    color: align == TextAlign.center
                        ? Colors.black87
                        : Colors.black26,
                    padding: const EdgeInsets.all(0),
                    onPressed: () {
                      MapController()
                          .setTextAlign(TextAlign.center, widget.widget);
                      setState(() {});
                    },
                    icon: Icon(Icons.format_align_center)),
                IconButton(
                  constraints: BoxConstraints.expand(width: 18, height: 18),
                    iconSize: 18,
                    color: align == TextAlign.right
                        ? Colors.black87
                        : Colors.black26,
                    padding: const EdgeInsets.all(0),
                    onPressed: () {
                      MapController()
                          .setTextAlign(TextAlign.right, widget.widget);
                      setState(() {});
                    },
                    icon: Icon(Icons.format_align_right)),
              ]),
            ),
            SelectionPanel<String>(
                title: LC.getString(context, C.font),
                selectedValue: family,
                count: 1,
                items: font_families,
                //widget: widget.widget,
                onChanged: (int index) {
                  Log.e("font family changed index = " + index.toString());
                  setState(() => family = font_families[index].title);
                  MapController()
                      .setFontFamily(font_families[index].value, widget.widget);
                },
                itemBuilder: (index, cur) {
                  return Text("Bernic");
                }),
            const Divider(indent: 10, thickness: 2),
            SelectionPanel<String>(
                title: LC.getString(context, C.background_color),
                selectedValue: "",
                //widget: widget.widget,
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
                //widget: widget.widget,
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
                //widget: widget.widget,
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
            const Divider(indent: 10, thickness: 2),
            SelectionPanel<String>(
                title: "边框颜色",
                selectedValue: "",
                //widget: widget.widget,
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
            SelectionPanel<int>(
              title: "边框样式",
              selectedValue: border_style,
              //widget: widget.widget,
              items: line_style,
              onChanged: (v) {
                border_style = v;
                setState(() {});
              },
              right: Container(
                  width: 100, height: 20, child: borderStyle(border_style)),
              itemBuilder: (index, cur) {
                return borderStyle(index);
              },
            ),
            const SizedBox(height: 7),
          ],
        )));
  }
}
