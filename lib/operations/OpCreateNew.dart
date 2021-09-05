import 'dart:io';
import 'dart:convert';
// import 'package:file_picker/file_picker.dart';

import '../MapController.dart';
import '../MindMap.dart';
import 'Operation.dart';

class OpCreateNew extends Operation {
  OpCreateNew(desc):super(desc) {
    will_record = false;
  }

  Future<void> doAction() {
    print("OpCreateNew");
    MindMap().Clear();
  }
}
