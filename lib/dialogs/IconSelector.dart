
import 'package:FlutterMind/MapController.dart';
import 'package:FlutterMind/Settings.dart';
import 'package:FlutterMind/third_party/SimpleImageButton.dart';
import 'package:FlutterMind/utils/Constants.dart';
import 'package:FlutterMind/utils/Log.dart';
import 'package:FlutterMind/utils/PopRoute.dart';
import 'package:FlutterMind/utils/Utils.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

List<dynamic> icons_rows = [
  [
    "arrow_down@16.png",
    "arrow_refresh@16.png",
    "arrow_up@16.png",
    "c_simbol_minus@24.png",
  ],
  [
    "c_simbol_plus@16.png",
    "c_simbol_pause@16.png",
    "c_simbol_plus@16.png",
    "c_simbol_pause@16.png",
  ]
];

class IconSelector extends StatefulWidget {
  IconSelector();

  static String getIconPathById(idx) {
    return C.tag_root + icons_rows[idx[0]][idx[1]];
  }

  static Future showDialog(BuildContext context, cb) async {
    dynamic result = await Navigator.push(context,
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierLabel:null,
        transitionDuration: Duration(milliseconds: 1000),
        transitionsBuilder: (ctx, anim1, anim2, child) {
          // return FadeTransition(opacity: Tween(begin: 0.0, end:1.0).
          //   animate(CurvedAnimation(parent: anim1, curve: Curves.fastOutSlowIn)), child:child);

          return new ScaleTransition(
            scale: new Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(
                CurvedAnimation(
                  parent: anim1,
                  curve: Interval(
                    0.00,
                    0.25,
                    curve: Curves.linear,
                  ),
                ),
              ),
            child: child,
           );
        },
        pageBuilder: (ctx, animation, secondanimation) {
          // return IconSelector();
          return Material(
            color: Colors.black26,
            child: Center(child:IconSelector()));
        }
    ));
    Log.e("result = " + result.toString());
    cb(result);
  }

  @override
  State<StatefulWidget> createState() {
    return IconSelectorState();
  }
}

class IconSelectorState extends State<IconSelector> {
  @override
  void initState() {
    super.initState();
    if (Utils().isAndroid) {
      print("IconSelectorState setEnabledSystemUIOverlays");
      SystemChrome.setEnabledSystemUIOverlays([]);
    }
  }

  List<Widget> makeImageButtonsRow(int row, List<dynamic> btns){
    List<Widget> btn_views = List<Widget>();
    for (int i = 0;i<btns[row].length; ++i) {
      Log.e("btns[i][0] = " + btns[row][i].toString());
      Log.e("btns[i][1] = " + btns[row][i].toString());
      btn_views.add(
        Container(
            width:50,
            height:50,
            color: Colors.white,
            child: SimpleImageButton(
              width: 50,
              mode: SIBMode.VERTICAL,
              normalImage: C.tag_root + btns[row][i],
              pressedImage: C.tag_root + btns[row][i],
              onPressed: () {
                Navigator.pop(context, [row, i]);
              },
            ),
        )
      );
    }
    return btn_views;
  }

  IconSelectorState() {}

  Widget build(BuildContext context) {
    return 
      // Container(
      //   decoration: BoxDecoration(
      //     border: Border.all(color: Colors.grey, width: 1),//边框
      //     borderRadius: BorderRadius.all(Radius.circular(5.0)),
      //     color: Colors.white,
      //     boxShadow: [
      //       BoxShadow(
      //         offset: Offset(6, 7),
      //         color: Colors.black12,
      //         blurRadius: 5, // 阴影的模糊程度
      //         spreadRadius: 0,
      //       )
      //     ],
      //   ),
      //   width: icons_rows[0].length * 50.toDouble() + 10,
      //   height: icons_rows.length * 50.toDouble() + 10,
      //   child: 
        // Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceAround,
        //       children: makeImageButtonsRow(0, icons_rows)
        //     ),
        //     Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceAround,
        //       children: makeImageButtonsRow(1, icons_rows)
        //     )
        //   ],
        // )

      Container(
        width: icons_rows[0].length * 50.toDouble() + 10,
        height: 5 * 50.toDouble() + 10,
      child:SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Row(children: makeImageButtonsRow(0, icons_rows))),
            SliverToBoxAdapter(
              child: Row(children: makeImageButtonsRow(1, icons_rows))),
            SliverToBoxAdapter(
              child: Row(children: makeImageButtonsRow(1, icons_rows))),
            SliverToBoxAdapter(
              child: Row(children: makeImageButtonsRow(1, icons_rows))),
            SliverToBoxAdapter(
              child: Row(children: makeImageButtonsRow(0, icons_rows))),
            SliverToBoxAdapter(
              child: Row(children: makeImageButtonsRow(1, icons_rows))),
            SliverToBoxAdapter(
              child: Row(children: makeImageButtonsRow(1, icons_rows))),
            SliverToBoxAdapter(
              child: Row(children: makeImageButtonsRow(1, icons_rows))),
            SliverToBoxAdapter(
              child: Row(children: makeImageButtonsRow(0, icons_rows))),
            SliverToBoxAdapter(
              child: Row(children: makeImageButtonsRow(1, icons_rows))),
            SliverToBoxAdapter(
              child: Row(children: makeImageButtonsRow(1, icons_rows))),
            SliverToBoxAdapter(
              child: Row(children: makeImageButtonsRow(1, icons_rows))),
            SliverToBoxAdapter(
              child: Row(children: makeImageButtonsRow(0, icons_rows))),
            SliverToBoxAdapter(
              child: Row(children: makeImageButtonsRow(1, icons_rows))),
            SliverToBoxAdapter(
              child: Row(children: makeImageButtonsRow(1, icons_rows))),
            SliverToBoxAdapter(
              child: Row(children: makeImageButtonsRow(1, icons_rows))),
          ],
        ),
      ),

        
    );
  }
}
