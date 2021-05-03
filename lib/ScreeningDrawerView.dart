import 'dart:ui';
import 'package:flutter/material.dart';

import 'operations/Operation.dart';
import 'utils/Utils.dart';

class ScreeningDrawerView extends StatefulWidget {
  List<Operation> operations;

  ScreeningDrawerView(this.operations);

  @override
  _ScreeningDrawerViewState createState() => _ScreeningDrawerViewState();
}

class _ScreeningDrawerViewState extends State<ScreeningDrawerView> {

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.only(left: 17,right: 17),
      color: Colors.white,
      height: Utils.screenSize().height,
      width: Utils.screenSize().width / 3,
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Text('主菜单', style: TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 20,),
            ),
            SliverGrid(
                delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
                  return InkWell(
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(0xff, 0xeb, 0xeb, 0xec),
                          borderRadius: BorderRadius.circular(4)
                      ),
                      child: Text(widget.operations[index].descrition),
                    ),
                    onTap: () {
                      print("item " + index.toString() + " clicked");
                      widget.operations[index].doAction();
                    },
                  );
                }, childCount: widget.operations.length),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 11,
                    mainAxisSpacing: 12,
                    childAspectRatio: 3.5)
            ),
          ],
        ),
      ),
    );
  }
}