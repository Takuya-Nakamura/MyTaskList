import 'package:flutter/material.dart';

class IconCheck extends StatefulWidget {
  @override
  _IconCheckState createState() => _IconCheckState();
}

//with TickerProviderStateMixinが必要
class _IconCheckState extends State<IconCheck> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<Color> colorAnim;
  Animation<double> sizeAnim;
  bool on = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    colorAnim =
        ColorTween(begin: Colors.grey, end: Colors.red).animate(_controller);

    sizeAnim = Tween<double>(begin: 30, end: 65).animate(
        new CurvedAnimation(parent: _controller, curve: Curves.easeInOutBack));
  }

  //***********************
  // Action
  //***********************
  Function toggleIcon() {
    on ? _controller.reverse() : _controller.forward();
    setState(() {
      on = !on;
    });
  }

  //***********************
  // build
  //***********************
  Widget build(BuildContext context) {
    var text = on ? '達成済!' : '未達成!';

    return AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return GestureDetector(
              onTap: () {
                toggleIcon();
              },
              child: Container(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Icon(
                    Icons.check_circle_outline_sharp,
                    color: colorAnim.value,
                    size: sizeAnim.value,
                  ),
                  Text(
                    text,
                    style: TextStyle(color: colorAnim.value),
                  )
                ]),
              ));
        });
  }
} //_IconCheckState
