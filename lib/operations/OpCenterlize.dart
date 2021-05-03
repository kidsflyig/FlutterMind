import '../Foreground.dart';
import 'Operation.dart';

class OpCenterlize extends Operation {
  Foreground foreground;
  OpCenterlize(this.foreground, desc):super(desc);

  void doAction() {
    print("OpCenterlize");
    foreground.centerlize();
  }
}
