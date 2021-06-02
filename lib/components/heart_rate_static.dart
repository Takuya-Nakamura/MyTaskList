import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import "dart:async";
import 'package:quiver/iterables.dart';

class HeartRate extends StatefulWidget {
  @override
  _HeartRateState createState() => _HeartRateState();
}

//with TickerProviderStateMixinが必要
class _HeartRateState extends State<HeartRate> with TickerProviderStateMixin {
  AnimationController _controller1;
  AnimationController _controller2;
  AnimationController _controller3;
  AnimationController _controller4;
  AnimationController _controller5;

  List<AnimationController> _controllers = [];

  // for state
  Animation<Color> colorAnim;
  Animation<double> sizeAnim;

  @override
  void initState() {
    super.initState();
    const duration = 600;

    _controller1 = AnimationController(
      duration: const Duration(milliseconds: duration),
      vsync: this,
    );
    _controller2 = AnimationController(
      duration: const Duration(milliseconds: duration),
      vsync: this,
    );
    _controller3 = AnimationController(
      duration: const Duration(milliseconds: duration),
      vsync: this,
    );
    _controller4 = AnimationController(
      duration: const Duration(milliseconds: duration),
      vsync: this,
    );
    _controller5 = AnimationController(
      duration: const Duration(milliseconds: duration),
      vsync: this,
    );

    // for (final i in range(1, 11)) {
    //   final controller = AnimationController(
    //     duration: const Duration(milliseconds: 400),
    //     vsync: this,
    //   );
    // }

    // final colorTween =
    //     ColorTween(begin: Colors.grey, end: Colors.pink);

    // final sizeTween = Tween<double>(begin: 30, end: 40);

    // for (final i in range(1, 11)) {
    //   final controller = AnimationController(
    //     duration: const Duration(milliseconds: 400),
    //     vsync: this,
    //   );
    // }

    colorAnim =
        ColorTween(begin: Colors.grey, end: Colors.pink).animate(_controller1);

    sizeAnim = Tween<double>(begin: 30, end: 40).animate(
        new CurvedAnimation(parent: _controller1, curve: Curves.elasticOut));
  }

  Widget build(BuildContext context) {
    return Container(
      child: Row(
        // children: _controllers.map((item) => oneIcon(item)),
        children: [
          oneIcon(_controller1),
          oneIcon(_controller2),
          oneIcon(_controller3),
          oneIcon(_controller4),
          oneIcon(_controller5),
        ],
      ),
    );
  }

  Widget oneIcon(AnimationController controller) {
    return GestureDetector(
        onTap: () {
          onTapIcon();
        },
        child: AnimatedBuilder(
            animation: controller,
            builder: (context, _) {
              return Icon(Icons.favorite,
                  color: colorAnim.value, size: sizeAnim.value);
            }));
  }

  void onTapIcon() async {
    print('hello');
    var ms = 100;
    _controller1.forward();
    await new Future.delayed(new Duration(milliseconds: ms));
    _controller2.forward();
    await new Future.delayed(new Duration(milliseconds: ms));
    _controller3.forward();
    await new Future.delayed(new Duration(milliseconds: ms));
    _controller4.forward();
    await new Future.delayed(new Duration(milliseconds: ms));
    _controller5.forward();

    // _controller2.forward();
    //TODO: 引数で経由した場合にうまく動かない
    //TODO: AnimationControllerを配列で宣言した場合もうまくうごかない..
    // _controllers[0].forward();
    // _controllers[1].forward();

    // controller.forward();
    // _controller2.forward();

    // var ms = 10;
    // _controllers.forEach((element) async {
    //   element.forward();
    //   await new Future.delayed(new Duration(milliseconds: ms));
    // });
  }
}
