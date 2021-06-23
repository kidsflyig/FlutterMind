class Log {
  static const String _TAG_DEF = "[FlutterMind]";

  static const int VERBOSE = 0;
  static const int INFO = 1;
  static const int ERROR = 2;

  static bool debuggable = true;
  static String TAG = _TAG_DEF;
  static int logLevel = ERROR;

  static void init({bool isDebug = false, String tag = _TAG_DEF, int level = ERROR}) {
    debuggable = isDebug;
    TAG = tag;
    logLevel = level;
  }

  static void e(Object object, {String tag}) {
    if (logLevel <= ERROR) {
      _printLog(tag, '  e  ', object);
    }
  }

  static void i(Object object, {String tag}) {
    if (debuggable && logLevel <= INFO) {
      _printLog(tag, '  i  ', object);
    }
  }

  static void v(Object object, {String tag}) {
    if (debuggable && logLevel <= VERBOSE) {
      _printLog(tag, '  v  ', object);
    }
  }

  static void _printLog(String tag, String stag, Object object) {
    StringBuffer sb = new StringBuffer();
    sb.write((tag == null || tag.isEmpty) ? TAG : tag);
    sb.write(stag);
    sb.write(object);
    print(sb.toString());
  }
}