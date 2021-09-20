import 'package:FlutterMind/MapController.dart';
import 'package:FlutterMind/dialogs/EditingDialog.dart';
import 'package:FlutterMind/utils/Log.dart';
import 'package:FlutterMind/utils/PopRoute.dart';
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

class ListViewData<T> {
  List<SelectionItem> items;
  String title = "";
  Function onChanged;
  Widget bottom;
  Function bottomOnPressed;
  int index = 0;
  Function itemBuilder;
}

class SelectionPanel<T> extends StatefulWidget {
  // Function onChanged;
  // Function confirm;
  Function onpressed;
  T selectedValue;

  Widget right;

  SelectionPanelState _state;
  ListViewData data = ListViewData();

  SelectionPanel(
      {Key key,
      String title,
      this.selectedValue,
      List<SelectionItem> items,
      // this.widget,
      Function onChanged,
      Function bottomOnPressed,
      Widget bottom,
      this.onpressed,
      this.right,
      Function itemBuilder,
      int count})
      : super(key: key) {
    data.items = items;
    data.onChanged = onChanged;
    data.bottom = bottom;
    data.itemBuilder = itemBuilder;
    data.title = title;
    data.bottomOnPressed = bottomOnPressed;

    // update index
    if (items != null) {
      for (int i = 0; i < items.length; i++) {
        if (items[i].value == selectedValue) {
          data.index = i;
          break;
        }
      }
    }
  }

  @override
  void dispose() {}

  @override
  State<StatefulWidget> createState() {
    _state = new SelectionPanelState();
    return _state;
  }
}

class SelectionPanelState extends State<SelectionPanel> {
  bool hover = false;

  static Future show(BuildContext ctx, ListViewData data) async {
    Log.e("show selection list dialog");
    var result = await showDialog(
        context: ctx,
        builder: (context) {
          return AlertDialog(content: SelectionListDialog(data));
        });

    return result;
  }

  static void showMyDialog(BuildContext context, ListViewData data) async {
    Navigator.push(context, PopRoute(child: SelectionListDialog(data)));
  }

  @override
  Widget build(BuildContext context) {
    Function onChanged = widget.data.onChanged;
    if (onChanged != null) {
      widget.data.onChanged = (newvalue) {
        print("function wrapper");
        onChanged(newvalue);
        setState(() {
          widget.selectedValue = widget.data.items[newvalue].value;
        });
      };
    }
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
            behavior: HitTestBehavior.deferToChild,
            onPanStart: (d) {
              hover = true;
              setState(() {});
            },
            onPanEnd: (d) {
              hover = false;
              setState(() {});
            },
            onPanCancel: () {
              hover = false;
              setState(() {});
            },
            onTap: () {
              hover = false;
              if (widget.onpressed == null) {
                showMyDialog(context, widget.data);
              } else {
                widget.onpressed();
              }
              setState(() {});
            },
            child: Container(
                height: 25,
                padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                color: hover ? Colors.grey : Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(widget.data.title), flex: 4),
                    Expanded(
                        child: Container(
                            alignment: Alignment.centerRight,
                            child: widget.right == null
                                ? Text(
                                    widget.selectedValue.toString(),
                                    style: TextStyle(fontSize: 15),
                                  )
                                : widget.right),
                        flex: 5),
                    Visibility(
                        visible: widget.right == null,
                        child:
                            Expanded(child: Icon(Icons.arrow_right), flex: 1)),
                  ],
                ))));
  }
}

class SelectionListDialog<T> extends StatefulWidget {
  ListViewData data;
  _SelectionListDialog _state;

  SelectionListDialog(this.data) {}

  @override
  void dispose() {}

  @override
  State<StatefulWidget> createState() {
    _state = new _SelectionListDialog();
    return _state;
  }
}

class _SelectionListDialog extends State<SelectionListDialog> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    var controller = new ScrollController();
    return Material(
      color: Colors.black26,
      child: Center(
        child: IntrinsicHeight(child:Column(children: [
      Container(
          color: Colors.white,
          width: 200,
          height: 200,
          child: new ListView.builder(
            itemCount: widget.data.items.length,
            controller: controller,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                  onTap: () {
                    updateGroupValue(index);
                  },
                  child: Container(
                      height: 50,
                      padding: EdgeInsets.only(
                          left: 10, top: 10, right: 10, bottom: 10),
                      // color:Colors.indigo,
                      decoration : BoxDecoration(
                        border: Border.all(color:Colors.black12),
                      ),
                      child:
                          widget.data.itemBuilder(index, widget.data.index)));
            },
          )),
      widget.data.bottom == null
          ? SizedBox(height: 1)
          : GestureDetector(
              onTap: () {
                Navigator.pop(context);
                if (widget.data.bottomOnPressed != null)
                  widget.data.bottomOnPressed();
              },
              child: Container(child:widget.data.bottom, color:Colors.white, width: 200, height:30))
    ]))));
  }

  void updateGroupValue(int i) {
    Log.e("updateGroupValue " + i.toString());
    setState(() {
      index = i;
    });
    if (widget.data.onChanged != null) {
      widget.data.onChanged(i);
    }
    Navigator.pop(context);
  }
}
