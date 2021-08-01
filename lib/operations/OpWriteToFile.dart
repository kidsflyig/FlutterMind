import 'dart:io';
import 'dart:convert';
// import 'package:file_picker/file_picker.dart';

import '../MapController.dart';
import '../MindMap.dart';
import 'Operation.dart';

class OpWriteToFile extends Operation {
  OpWriteToFile(desc):super(desc);

  Future<void> saveToFile() async {
    // FilePickerResult result = await FilePicker.platform.pickFiles();

    // if(result != null) {
      // File file = File(result.files.single.path);
      // print("file name:" + file.toString());
      // String data = await file.readAsString();

      String data = MindMap().toJson();
      print("saveToFile " + data);

    // } else {
    //   print("pick file failed: " + result.toString());
    //   // User canceled the picker
    // }
  }

  Future<void> doAction() {
    print("OpWriteToFile");
    // print('OS: ${Platform.operatingSystem}');
    saveToFile();
  }
}
