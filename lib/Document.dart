import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'Settings.dart';

class Document {
  Document._privateConstructor();

  Settings s = Settings();
  static Document _instance = null;

  factory Document() {
    if (_instance == null) {
      _instance = Document._privateConstructor();
    }
    return _instance;
  }

  Future<File> _getLocalFile(path) async {
    // get the path to the document directory.
    // String dir = (await getApplicationDocumentsDirectory()).path;
    // print("app dir = " + dir);
    return new File('D:\test.txt');
  }

  void loadFromFile(path) async {
    print("Document: loadFromFile");
    // File file = await _getLocalFile("test.txt");
    // String temp = await file.readAsString();
    // print("Document: loadFromFile2 " + temp);

    var httpClient = new HttpClient();
    var uri = new Uri.http(
        'file://', 'D:/test.txt');
    var request = await httpClient.getUrl(uri);
    var response = await request.close();
    var responseBody = await response.transform(utf8.decoder).join();
    print("resp " + responseBody);
  }
}