import 'dart:io';
import 'dart:convert';
// import 'package:file_picker/file_picker.dart';

import 'package:FlutterMind/utils/FileUtil.dart';

import '../MapController.dart';
import '../MindMap.dart';
import 'Operation.dart';

class OpLoadFromFile extends Operation {
  String path;
  OpLoadFromFile(this.path):super("Load") {
    will_record = false;
  }

  Future<void> doAction() {
    print("OpLoadFromFile");
    // print('OS: ${Platform.operatingSystem}');
    FileUtil().loadFromFile(path + ".fm").then((data) {
      print("OpLoadFromFile1 "+ data);
      MindMap().fromJson(data);
    });
  }
}
