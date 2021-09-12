import 'package:FlutterMind/MapController.dart';
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

class SelectionPanel<T> extends StatefulWidget {
  String title;
  T selectedValue;
  List<SelectionItem> choiceItems;
  Function onChanged;
  Function confirm;
  Function onpressed;
  Widget widget;
  Widget right;
  SelectionPanelState _state;

  SelectionPanel(
      {Key key,
      this.title,
      this.selectedValue,
      this.choiceItems,
      this.widget,
      this.onChanged,
      this.confirm,
      this.onpressed,
      this.right
      })
      : super(key: key) {
  }

  @override
  void dispose() {

  }

  @override
  State<StatefulWidget> createState() {
    _state = new SelectionPanelState();
    return _state;
  }
}

class SelectionPanelState extends State<SelectionPanel> {
  bool hover = false;

  static Future show(
      BuildContext ctx, title, selectedValue, choiceItems, onChange, confirm, widget) async {
    var result = await showDialog(
        context: ctx,
        builder: (context) {
          return AlertDialog(
              content: SelectionListDialog(
                  title: title,
                  selectedValue: selectedValue,
                  choiceItems: choiceItems,
                  widget: widget,
                  onChange: onChange,
                  confirm: confirm));
        });

    return result;
  }

  @override
  Widget build(BuildContext context) {
    Function wrapper = (newvalue) {
      print("function wrapper");
      widget.onChanged(newvalue);
      setState(() {
        widget.selectedValue = newvalue;
      });
    };
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
            onPanStart: (d) {
              hover = true;
              setState(() {});
            },
            onPanEnd:(d) {
              hover = false;
              setState(() {});
            },
            onTap: () {
              hover = false;
              if (widget.onpressed == null) {
                show(context, widget.title, widget.selectedValue,
                    widget.choiceItems, wrapper, widget.confirm, widget.widget);
              } else {
                widget.onpressed();
              }
              setState(() {});
            },
            child: Container(
                padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                color: hover ? Colors.grey : Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(widget.title), flex: 6),
                    Expanded(
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: widget.right == null ?
                            Text(widget.selectedValue.toString(),
                            style: TextStyle(fontSize: 15),
                            ) :
                          widget.right),
                        flex: 4),
                    Expanded(child: Icon(Icons.arrow_right), flex: 1),
                  ],
                ))));
  }
}

class SelectionListDialog<T> extends StatefulWidget {
  String title;
  T selectedValue;
  List<SelectionItem> choiceItems;
  Widget widget;
  Function onChange;
  Function confirm;
  _SelectionListDialog _state;

  SelectionListDialog(
      {Key key,
      this.title,
      this.selectedValue,
      this.choiceItems,
      this.widget,
      this.onChange,
      this.confirm
      })
      : super(key: key) {
  }

  @override
  void dispose() {
  }

  @override
  State<StatefulWidget> createState() {
    _state = new _SelectionListDialog();
    return _state;
  }

  void update(choices, selected) {
    choiceItems = choices;
    selectedValue = selected;
    if (_state != null && _state.mounted)
      _state.setState(() {});
  }
}

class _SelectionListDialog extends State<SelectionListDialog> {
  int group_value = -1;
  List<Widget> w;
  @override
  Widget build(BuildContext context) {
    Log.e("_SelectionListDialog build " + widget.selectedValue.toString()+", choiceItems len="+
    widget.choiceItems.length.toString());

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
            if (widget.onChange != null) {
              Log.e("updateGroupValue changed to： " + widget.choiceItems[T].toString());
              widget.onChange(widget.choiceItems[T].value);
            }
            updateGroupValue(T);
          }));
    });
    // add confirm widget
    w.add(
      TextButton(
        child: Text(LC.getString(context, C.save_as_tempate)),
        onPressed: () {
          widget.confirm(widget);
        }
      )
    );

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
    Navigator.pop(context);
  }
}
