import 'package:FlutterMind/utils/ScreenUtil.dart';

enum MapMode {
  star,
  bidi
}

class Settings {
  MapMode mode = MapMode.bidi;

  double get default_font_size {
    return ScreenUtil.getDp(plain_text_node_font_size_100p);
  }

}