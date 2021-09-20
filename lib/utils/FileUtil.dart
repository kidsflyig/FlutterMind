import 'dart:io';

import 'package:FlutterMind/utils/Log.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class FileUtil {
  Directory root_path;

  FileUtil._privateConstructor();

  static FileUtil _instance = null;

  factory FileUtil() {
    if (_instance == null) {
      _instance = FileUtil._privateConstructor();
    }
    return _instance;
  }

  Future<Directory> get _rootPath async {
    root_path = await getApplicationDocumentsDirectory();
    return root_path;
  }

  Future<bool> exists(String name) async {
    File file = await mkFile(name);
    bool res = await file.exists();
    return res;
  }

  Future<File> mkFile(String name) async {
    final path = await _rootPath;
    String path_str = path.path;
    File file = File('$path_str/' + name);
    return file;
  }

  File mkFileSync(String name) {
    if (root_path == null) {
      return null;
    }

    String path_str = root_path.path;
    File file = File('$path_str/' + name);
    return file;
  }

  Future<File> loadFileFromFilePicker() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result != null) {
      return File(result.files[0].path);
    } else {
      return null;
    }
  }

  Future<String> loadDataFromFilePicker() async {
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

  Future<bool> writeDataToFile(data, String file_name) async {
    File f = await mkFile(file_name);
    if (f != null) {
      f.writeAsBytes(data);
      return true;
    } else {
      return false;
    }
  }

  Future<Map<String, File>> getPreviews() async {
    final Directory path = await _rootPath;
    Map<String, File> map = Map<String, File>();
    path
      .list()
      .where((FileSystemEntity entity) => entity.path.endsWith(".cap"))
      .forEach((entity) {
        var key = basenameWithoutExtension(entity.path);
        map[key] = File(entity.path);
      });
    return map;
  }
}
