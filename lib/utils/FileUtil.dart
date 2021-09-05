import 'dart:io';

import 'package:FlutterMind/utils/Log.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class FileUtil {
  String root_path;

  FileUtil._privateConstructor();

  static FileUtil _instance = null;

  factory FileUtil() {
    if (_instance == null) {
      _instance = FileUtil._privateConstructor();
    }
    return _instance;
  }

  Future<Directory> get _rootPath async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    return appDocDir;
  }

  Future<bool> exists(String name) async {
    File file = await mkFile(name);
    bool res = await file.exists();
    return res;
  }

  Future<File> mkFile(String name) async {
    final path = await _rootPath;
    String path_str = path.path;
    File file = File('$path_str/' + name + '.fm');
    return file;
  }

  Future<String> loadFromFilePicker() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result != null) {
      String data = await loadFromFile(result.files.single.path);
      return data;
    }
    return "";
  }

  Future<String> loadFromFile(String name) async {
    File file = await mkFile(name);
    String data = await file.readAsString();
    return data;
  }

  Future<bool> writeToFile(String file_name, String data) async {
    File f = await mkFile(file_name);
    if (f != null) {
      f.writeAsString(data);
      return true;
    } else {
      return false;
    }
    ;
  }

  Future<List<String>> getFileList() async {
    final Directory path = await _rootPath;
    return path
        .list()
        .where((FileSystemEntity entity) => entity.path.endsWith(".fm"))
        .map((entity) => basenameWithoutExtension(entity.path))
        .toList();
  }

  Future<void> delete(String name) async {
    if (name == null || name.isEmpty) return;
    File file = await mkFile(name);
    file.delete();
  }
}
