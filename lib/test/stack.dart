

import 'package:flutter/material.dart';


void main() {
  runApp(MaterialApp(home:TestStack()));
}

class TestStack extends StatefulWidget {


  TestStackdState state_;


  @override
  State<StatefulWidget> createState() {
    state_ = TestStackdState();
    return state_;
  }
}

class TestStackdState extends State<TestStack> {
  List<Widget> widget_list = [];
  bool re = false;
  TestStackdState() {
    Widget w = Container (
      child: IconButton (
        icon: new Icon(Icons.star),
        onPressed: () {
          List<Widget> widget_list1= [];
          Widget w = Container (
           padding: EdgeInsets.only(left: 17,right: 17),
          child: IconButton (
            icon: new Icon(Icons.face)
          ));
          widget_list.add(w);
          print("set state000");
          setState(() {
            print("set state111");
            // widget_list = widget_list1;
            re = true;
          });
        },
      ),
    );

    widget_list.add(w);
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:Container(
        color: re ? Color.fromARGB(0x00, 0, 0, 0) : Colors.red,
        child: new Stack(
          children: widget_list
        )
      )
    );
  }
}