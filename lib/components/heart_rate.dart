import 'package:flutter/material.dart';
import "dart:async";
import 'package:quiver/iterables.dart';

class HeartRate extends StatefulWidget {
  @override
  _HeartRateState createState() => _HeartRateState();
}

//with TickerProviderStateMixinが必要
class _HeartRateState extends State<HeartRate> with TickerProviderStateMixin {
  List<AnimationObject> _animationObjects = [];
  int currentSelectedIndex = 0;

  double rowHeight = 35;
  double iconSizeBegin = 25;
  double iconSizeEnd = 35;
  double iconContanerHeight = 35;
  double iconContanerWidth = 35;

  int controllerDuration = 200;
  int iconAnimationDuration = 100;

  @override
  void initState() {
    super.initState();
    const iconCount = 5;

    for (final i in range(1, iconCount + 1)) {
      final controller = AnimationController(
        duration: Duration(milliseconds: this.controllerDuration),
        vsync: this,
      );
      final colorAnim =
          ColorTween(begin: Color(0xffdddddd), end: Color(0xffd81a1a))
              .animate(controller);
      final sizeAnim =
          Tween<double>(begin: this.iconSizeBegin, end: iconSizeEnd).animate(
              new CurvedAnimation(
                  parent: controller, curve: Curves.elasticOut));
      _animationObjects.add(new AnimationObject(
          controller: controller,
          colorAnim: colorAnim,
          sizeAnim: sizeAnim,
          index: i));
    }
    _animationObjects[0].controller.forward();
  }

  //***********************
  // Action
  //***********************
  void upSelect(int index) async {
    Future.forEach(_animationObjects, (element) async {
      if (element.index <= index) {
        element.controller.forward();
        await new Future.delayed(
            new Duration(milliseconds: this.iconAnimationDuration));
      }
    });
  }

  void downSelect(int index) async {
    Future.forEach(_animationObjects.reversed, (element) async {
      if (element.index > index) {
        element.controller.reverse();
        await new Future.delayed(
            new Duration(milliseconds: this.iconAnimationDuration));
      }
    });
  }

  //***********************
  // build
  //***********************
  Widget build(BuildContext context) {
    return Container(
      height: this.rowHeight,
      child: Row(
        children: _animationObjects.map((e) => oneIcon(e)).toList(),
      ),
    );
  }

  //***********************
  // Widget
  //***********************

  Widget oneIcon(AnimationObject anim) {
    return GestureDetector(
        onTap: () {
          currentSelectedIndex < anim.index
              ? upSelect(anim.index)
              : downSelect(anim.index);
          currentSelectedIndex = anim.index;
        },
        child: AnimatedBuilder(
            animation: anim.controller,
            builder: (context, _) {
              return Container(
                height: this.iconContanerHeight,
                width: this.iconContanerWidth,
                child: Icon(Icons.favorite,
                    color: anim.colorAnim.value, size: anim.sizeAnim.value),
              );
            }));
  }
} //_HeartRateState

//***********************
// Entity
//***********************
class AnimationObject {
  AnimationController controller;
  Animation<Color> colorAnim;
  Animation<double> sizeAnim;
  int index;

  AnimationObject(
      {AnimationController controller,
      Animation<Color> colorAnim,
      Animation<double> sizeAnim,
      int index}) {
    this.controller = controller;
    this.colorAnim = colorAnim;
    this.sizeAnim = sizeAnim;
    this.index = index;
  }
}
