import 'dart:io';
import 'dart:convert';
// import 'package:file_picker/file_picker.dart';

import 'package:FlutterMind/MapController.dart';
import 'package:FlutterMind/MindMap.dart';
import 'package:FlutterMind/utils/FileUtil.dart';
import 'package:FlutterMind/utils/Log.dart';
import 'package:FlutterMind/utils/Utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Operation.dart';

class OpWriteToFile extends Operation {
  String old_file_name;
  String new_file_name;
  OpWriteToFile(this.old_file_name, this.new_file_name):super("Save") {
    will_record = false;
  }

  void doAction() {
    WriteToFile();
  }

  Future<void> WriteToFile() async {
    String data = MindMap().toJson();
    String file_name = new_file_name;
    if (new_file_name == null || new_file_name.isEmpty) {
      file_name = "未命名";
      int id = 1;
      while (await FileUtil().exists(file_name)) {
        file_name = file_name + "_$id";
        id++;
      }
    }
    print("OpWriteToFile file_name= " + file_name);
    if (Utils().is_android) {
      bool res = await FileUtil().writeToFile(file_name + ".fm", data);
      if (res) {
        print("OpWriteToFile 000000 ");
        Fluttertoast.showToast(msg: "保存成功");

        if (old_file_name != new_file_name && old_file_name != null && old_file_name.isNotEmpty) {
          await FileUtil().delete(old_file_name + ".fm");
          await FileUtil().delete(old_file_name + ".cap");
        }

        MapController().caputre((data) async {
          await FileUtil().writeDataToFile(data, file_name + ".cap");
        });
      } else {
        print("OpWriteToFile 111111");
        Fluttertoast.showToast(msg: "保存失败");
      };
    } else {
      Log.i("write to file, content = " + data);
    }
  }
}
