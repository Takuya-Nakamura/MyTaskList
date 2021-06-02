import 'package:flutter/material.dart';
import "dart:async";
import 'package:quiver/iterables.dart';

class IconSwitch extends StatefulWidget {
  @override
  _IconSwitchState createState() => _IconSwitchState();
}

//with TickerProviderStateMixinが必要
class _IconSwitchState extends State<IconSwitch> with TickerProviderStateMixin {
  AnimationController _controller1;
  AnimationController _controller2;

  Animation<Color> colorAnim1;
  Animation<double> sizeAnim1;

  Animation<Color> colorAnim2;
  Animation<double> sizeAnim2;

  bool on = true;
  @override
  void initState() {
    super.initState();
    _controller1 = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _controller2 = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    colorAnim1 =
        ColorTween(begin: Colors.grey, end: Colors.green).animate(_controller1);

    sizeAnim1 = Tween<double>(begin: 30, end: 45).animate(
        new CurvedAnimation(parent: _controller1, curve: Curves.easeInOutBack));

    colorAnim2 =
        ColorTween(begin: Colors.grey, end: Colors.red).animate(_controller2);

    sizeAnim2 = Tween<double>(begin: 30, end: 45).animate(
        new CurvedAnimation(parent: _controller2, curve: Curves.easeInOutBack));

    initIcon();
  }

  //***********************
  // Action
  //***********************
  Function initIcon() {
    if (on) {
      _controller1.forward();
    } else {
      _controller2.forward();
    }
  }

  Function toggleIcon() {
    if (on) {
      _controller1.reverse();
      _controller2.forward();
    } else {
      _controller1.forward();
      _controller2.reverse();
    }
    setState(() {
      on = !on;
    });
  }

  //***********************
  // build
  //***********************
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      child: Container(
        height: 65,
        child: Row(
          textBaseline: TextBaseline.alphabetic,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [icon1(), icon2()],
        ),
      ),
    );
  }

  Widget icon1() {
    return GestureDetector(
        onTap: () {
          toggleIcon();
        },
        child: AnimatedBuilder(
            animation: _controller1,
            builder: (context, _) {
              return Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.sentiment_very_satisfied,
                      color: colorAnim1.value,
                      size: sizeAnim1.value,
                    ),
                    Text("たのしみ！", style: TextStyle(color: colorAnim1.value)),
                  ],
                ),
              );
            }));
  }

  Widget icon2() {
    return GestureDetector(
        onTap: () {
          toggleIcon();
        },
        child: AnimatedBuilder(
            animation: _controller2,
            builder: (context, _) {
              return Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.sentiment_very_dissatisfied,
                      color: colorAnim2.value,
                      size: sizeAnim2.value,
                    ),
                    Text("つらい！", style: TextStyle(color: colorAnim2.value)),
                  ],
                ),
              );
            }));
  }
} //_IconSwitchState
