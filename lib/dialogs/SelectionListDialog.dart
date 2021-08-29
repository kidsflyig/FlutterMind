import 'package:FlutterMind/MapController.dart';
import 'package:FlutterMind/StyleManager.dart';
import 'package:FlutterMind/dialogs/EditingDialog.dart';
import 'package:FlutterMind/utils/Log.dart';
import 'package:FlutterMind/utils/Utils.dart';
import 'package:FlutterMind/utils/Localization.dart';
import 'package:FlutterMind/widgets/NodeWidgetBase.dart';
import 'package:flutter/material.dart';
import 'package:FlutterMind/utils/Constants.dart';

class SelectionItem {
  int id;
  String title;
  dynamic value;
  SelectionItem({this.value, this.title, this.id});
}

class PopRoute extends PopupRoute {
  final Duration _duration = Duration(milliseconds: 300);
  Widget child;

  PopRoute({@required this.child});

  @override
  Color get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return child;
  }

  @override
  Duration get transitionDuration => _duration;
}

class SelectionPanel<T> extends StatefulWidget implements StyleListChangedListener {
  String title;
  T selectedValue;
  List<SelectionItem> choiceItems;
  Function onChange;
  Widget widget;
  SelectionPanelState _state;

  SelectionPanel(
      {Key key,
      this.title,
      this.selectedValue,
      this.choiceItems,
      this.widget,
      this.onChange})
      : super(key: key) {
    StyleManager().addStyleListChangedListener(this);
  }

  @override
  void dispose() {
    StyleManager().removeStyleListChangedListener(this);
  }

  @override
  void onChanged(choices) {
    choiceItems = choices;
    if (_state != null && _state.mounted)
      _state.setState(() {});
  }

  @override
  State<StatefulWidget> createState() {
    _state = new SelectionPanelState();
    return _state;
  }
}

class SelectionPanelState extends State<SelectionPanel> {
  int groupValue = 1;
  List<Widget> w;
  bool hover = false;

  static Future show(
      BuildContext ctx, title, selectedValue, choiceItems, onChange, widget) async {
    var result = await showDialog(
        context: ctx,
        builder: (context) {
          return AlertDialog(
              content: SelectionListDialog(
                  title: title,
                  selectedValue: selectedValue,
                  choiceItems: choiceItems,
                  widget: widget,
                  onChange: onChange));
        });
    print("result   -- >  " + result.toString());
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        onHover: (e) {
          hover = true;
          setState(() {});
        },
        onExit: (e) {
          hover = false;
          setState(() {});
        },
        child: GestureDetector(
            onTap: () {
              show(context, widget.title, widget.selectedValue,
                  widget.choiceItems, widget.onChange, widget.widget);
            },
            child: Container(
                color: hover ? Colors.grey : Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(widget.title), flex: 8),
                    Expanded(
                        child: Text(widget.title.toString()), flex: 1),
                    Expanded(child: Icon(Icons.arrow_right), flex: 1),
                  ],
                ))));
  }
}

class SelectionListDialog<T> extends StatefulWidget implements StyleListChangedListener {
  String title;
  T selectedValue;
  List<SelectionItem> choiceItems;
  Widget widget;
  Function onChange;
  _SelectionListDialog _state;

  SelectionListDialog(
      {Key key,
      this.title,
      this.selectedValue,
      this.choiceItems,
      this.widget,
      this.onChange})
      : super(key: key) {
    StyleManager().addStyleListChangedListener(this);
  }

  @override
  void dispose() {
    StyleManager().removeStyleListChangedListener(this);
  }

  @override
  State<StatefulWidget> createState() {
    _state = new _SelectionListDialog();
    return _state;
  }

  @override
  void onChanged(choices) {
    choiceItems = choices;
    if (_state != null && _state.mounted)
      _state.setState(() {});
  }
}

class _SelectionListDialog extends State<SelectionListDialog> {
  int group_value = -1;
  List<Widget> w;
  @override
  Widget build(BuildContext context) {
    Log.e("_SelectionListDialog build " + widget.selectedValue.toString());

    w = List<Widget>();
    int i = 0;
    if (group_value < 0) {
      for (int i=0;i<widget.choiceItems.length;i++) {
        if (widget.choiceItems[i].value == widget.selectedValue) {
          group_value = i;
          break;
        }
      }
      i = 0;
    }
    Log.e("_SelectionListDialog build group_value=" + group_value.toString());
    w.add(Text(widget.title));
    widget.choiceItems.forEach((element) {
      Log.e("_SelectionListDialog build2 " + element.id.toString());

      w.add(RadioListTile(
          value: i++,
          groupValue: group_value,
          title: new Text(element.title),
          onChanged: (int T) {
            Log.e("updateGroupValue " + T.toString());
            if (widget.onChange != null)
              widget.onChange(widget.choiceItems[T].value);
            updateGroupValue(T);
          }));
    });
    w.add(TextButton(
      child: Text(LC.getString(context, C.save_as_tempate)),
      onPressed: () {

        EditingDialog.showMyDialog(context, EditConfig(
            pos: Utils.center(),
            maxLength: 20,
            maxLines:1,
            keyboardType : TextInputType.text,
            textInputAction: TextInputAction.done,
            onSubmit: (msg) {
              MapController().saveAsTemplate(widget.widget, msg);
            }
        ));

      },
    ));

    return Container(
        width: 100,
        height: 300,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: w,
        ));
  }

  void updateGroupValue(int v) {
    setState(() {
      group_value = v;
      widget.selectedValue = widget.choiceItems[v];
    });
  }
}
