import 'dart:io';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';

import '../MapController.dart';
import '../MindMap.dart';
import 'Operation.dart';

class OpLoadFromFile extends Operation {
  OpLoadFromFile(desc):super(desc);

  Future<void> loadFile() async {
    // FilePickerResult result = await FilePicker.platform.pickFiles();

    // if(result != null) {
      // File file = File(result.files.single.path);
      // print("file name:" + file.toString());
      // String data = await file.readAsString();
      String data = "{\"title\":\"world\",\"children\": [{\"title\":\"hel\"},{\"title\":\"llo\"},{\"title\":\"llo\"}]}";
      print("test data " + data);
      MindMap().fromJson(data);


    // } else {
    //   print("pick file failed: " + result.toString());
    //   // User canceled the picker
    // }
  }

  Future<void> doAction() {
    print("OpLoadFromFile");
    // print('OS: ${Platform.operatingSystem}');
    loadFile();
  }
}
