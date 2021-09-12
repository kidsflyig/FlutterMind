import 'dart:io';

import 'package:FlutterMind/MapController.dart';
import 'package:FlutterMind/operations/OpLoadFromFile.dart';
import 'package:FlutterMind/utils/FileUtil.dart';
import 'package:FlutterMind/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MindMapBrowser extends StatefulWidget {
  MindMapBrowserState state;
  List<String> file_list;
  Map<String, File> previews;

  MindMapBrowser() {
    file_list = new List<String>();
    updateFileList();
  }

  void updateFileList() {
    file_list.clear();
    FileUtil().getFileList().then((value) {
      file_list = value;
      _update();
    });

    FileUtil().getPreviews().then((value) {
      previews = value;
      _update();
    });
  }

  void _update() {
    if (state != null && state.mounted) {
      state.setState(() {});
    }
  }

  @override
  State<StatefulWidget> createState() {
    state = MindMapBrowserState();
    return state;
  }
}

class MindMapBrowserState extends State<MindMapBrowser> {
  String selected;
  Map<String, File> previews = Map<String, File>();

  @override
  void initState() {
    super.initState();
    if (Utils().isAndroid) {
      SystemChrome.setEnabledSystemUIOverlays([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    // updatePreviews();
    List<Widget> widget_list = <Widget>[];
    for (int i = 0; i< widget.file_list.length; i++) {
      var element = widget.file_list[i];
      var preview = widget.previews[element];
      widget_list.add(
        GestureDetector(
            child: Column(children: [
              // Container(
              //   width: 100,
              //   height: 100,
              //   decoration: BoxDecoration(
              //       color: Colors.red,
              //       border: Border.all(
              //           color: selected == element
              //               ? Colors.grey
              //               : Colors.transparent,
              //           width: 3),
              //       borderRadius: BorderRadius.circular(4)),
              // ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.black26,
                    border: Border.all(
                        color: selected == element
                            ? Colors.deepOrange
                            : Colors.transparent,
                        width: 3),
                    borderRadius: BorderRadius.circular(4)),
                child:
              Image(
                width: 100,
                height: 100,
                fit: BoxFit.fitWidth,
                image: Image.file(preview).image
              )),
              Text(element)
            ]),
            onTap: () {
              selected = element;
              setState(() {});
            }),
      );
    }
    return new Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          shadowColor: Colors.transparent,
          backgroundColor: Colors.black26,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back)),
          title: Text("文档管理"),
          toolbarHeight: 50,
          // toolbarOpacity: 0,
          bottomOpacity: 0,
          actions: [
            IconButton(
                onPressed: () {
                  MapController().load(selected);
                  Navigator.pop(context);
                },
                icon: Icon(Icons.menu_open)),
            IconButton(
                onPressed: () {
                  MapController().delete(selected);
                  widget.updateFileList();
                },
                icon: Icon(Icons.delete)),
            IconButton(
                onPressed: () {
                  // TODO login
                },
                icon: Icon(Icons.share)),
          ],
        ),
        body: SingleChildScrollView(
          child: Wrap(
            spacing: 5,
            runSpacing: 5,
            children: widget_list,
          ),
        ));
  }
}
