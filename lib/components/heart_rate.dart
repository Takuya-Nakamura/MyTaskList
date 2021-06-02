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

  @override
  void initState() {
    super.initState();
    const iconCount = 8;

    for (final i in range(1, iconCount + 1)) {
      final controller = AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
      );
      final colorAnim =
          ColorTween(begin: Colors.blueGrey, end: Colors.pinkAccent)
              .animate(controller);
      final sizeAnim = Tween<double>(begin: 35, end: 50).animate(
          new CurvedAnimation(parent: controller, curve: Curves.elasticOut));
      _animationObjects.add(new AnimationObject(
          controller: controller,
          colorAnim: colorAnim,
          sizeAnim: sizeAnim,
          index: i));
    }
  }

  //***********************
  // Action
  //***********************
  void upSelect(int index) async {
    Future.forEach(_animationObjects, (element) async {
      if (element.index <= index) {
        element.controller.forward();
        await new Future.delayed(new Duration(milliseconds: 100));
      }
    });
  }

  void downSelect(int index) async {
    Future.forEach(_animationObjects.reversed, (element) async {
      if (element.index > index) {
        element.controller.reverse();
        await new Future.delayed(new Duration(milliseconds: 100));
      }
    });
  }

  //***********************
  // build
  //***********************
  Widget build(BuildContext context) {
    return Container(
      height: 50,
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
                height: 50,
                width: 50,
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
