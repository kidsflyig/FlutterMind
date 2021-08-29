import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum SIBMode {
  OVERRIDE,
  VERTICAL,
}

class SimpleImageButton extends StatefulWidget {
  final String normalImage;
  final String pressedImage;
  final Function onPressed;
  final double width;
  final String title;
  final SIBMode mode;

  const SimpleImageButton({
    Key key,
    @required this.normalImage,
    @required this.pressedImage,
    @required this.onPressed,
    @required this.width,
    this.title,
    this.mode
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SimpleImageButtonState();
  }
}

class _SimpleImageButtonState extends State<SimpleImageButton> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ImageButton(
      mode : widget.mode,
      width: widget.width,
      normalImage: Image(
        image: AssetImage(widget.normalImage),
        width: widget.width,
        height: (widget.mode == null || widget.mode == SIBMode.OVERRIDE) ? widget.width :  widget.width - 17,
      ),
      pressedImage: Image(
        image: AssetImage(widget.pressedImage),
        width: widget.width,
        height: (widget.mode == null || widget.mode == SIBMode.OVERRIDE) ? widget.width :  widget.width - 17,
      ),
      title: widget.title == null ? '' : widget.title,
      //文本是否为空
      normalStyle: TextStyle(
          color: Colors.black, fontSize: 12, decoration: TextDecoration.none),
      pressedStyle: TextStyle(
          color: Colors.black45, fontSize: 11, decoration: TextDecoration.none),
      onPressed: widget.onPressed,
    );
  }
}

/*
 * 图片 按钮
 */
class ImageButton extends StatefulWidget {
  //常规状态
  final Image normalImage;

  //按下状态
  final Image pressedImage;

  //按钮文本
  final String title;

  //常规文本TextStyle
  final TextStyle normalStyle;

  //按下文本TextStyle
  final TextStyle pressedStyle;

  //按下回调
  final Function onPressed;

  //文本与图片之间的距离
  final double padding;

  final double width;

  final SIBMode mode;

  ImageButton({
    Key key,
    @required this.normalImage,
    @required this.pressedImage,
    @required this.onPressed,
    this.title,
    this.normalStyle,
    this.pressedStyle,
    this.padding,
    this.width,
    this.mode
  }) : super(key: key);

  @override
  _ImageButtonState createState() {
    return _ImageButtonState();
  }
}

class _ImageButtonState extends State<ImageButton> {
  var isPressed = false;

  @override
  Widget build(BuildContext context) {
    double padding = widget.padding == null ? 5 : widget.padding;
    return GestureDetector(
      child: Container(
        width:widget.width,
        height:widget.width,
        child:
          (widget.mode == null || widget.mode == SIBMode.OVERRIDE) ?
          Stack(
        children: <Widget>[
          isPressed ? widget.pressedImage : widget.normalImage,
          Center(child: Text(
            widget.title,
            style: isPressed ? widget.pressedStyle : widget.normalStyle,
          ))
        ],
      ) : Column(
        children: <Widget>[
          isPressed ? widget.pressedImage : widget.normalImage,
          Text(
            widget.title,
            style: isPressed ? widget.pressedStyle : widget.normalStyle,
          )
        ],
      )
      )
      ,
      onTap: widget.onPressed,
      onTapDown: (d) {
        setState(() {
          isPressed = true;
        });
      },
      onTapCancel: () {
        setState(() {
          isPressed = false;
        });
      },
      onTapUp: (d) {
        setState(() {
          isPressed = false;
        });
      },
    );
  }
}