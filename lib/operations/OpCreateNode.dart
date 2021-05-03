import 'Operation.dart';

class OpCreateNode extends Operation {
  OpCreateNode(desc):super(desc);

  void doAction() {
    print("OpCreateNode");
  }
}
