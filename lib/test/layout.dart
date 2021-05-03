import 'package:flutter/material.dart';

 void main() => runApp(MaterialApp(
       title: 'Travel',
       home: HomePage(),
     ));

 class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  return Scaffold(
        appBar: AppBar(
          title: Text('Container'),
        ),
        body: Stack(
          children: [
            Positioned(
              left:-10,
              child:Text('Text in Container'),
            )]
        ),
      );

 }

}