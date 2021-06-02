import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';

class AniamtedIconButton extends StatefulWidget {
  @override
  _AniamtedIconButtonState createState() => _AniamtedIconButtonState();
}

//with TickerProviderStateMixinが必要
class _AniamtedIconButtonState extends State<AniamtedIconButton>
    with TickerProviderStateMixin {
  AnimationController _controller;

  Animation<Color> _animColor;

  // for state
  Animation<Color> colorAnim;
  Animation<double> paddingAnim;
  Animation<double> sizeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    //1個のプロパティを操作するなら controller.drive(tween)で設定する
    // _animColor =
    //     _controller.drive(ColorTween(begin: Colors.blue, end: Colors.red));

    //複数プロパティのアニメーションが必要なら、tween.animated()でcontrollerに紐付ける。
    //その戻り値をwidgetの任意のプロパティにセットする
    colorAnim =
        ColorTween(begin: Colors.grey, end: Colors.pink).animate(_controller);

    // paddingAnim = Tween<double>(begin: 10, end: 80).animate(_controller);
    // sizeAnim = Tween<double>(begin: 40, end: 80).animate(_controller);
    // .chain(Tween<double>(begin: 1, end: 2))
    // .chain(Tween<double>(begin: 1, end: 0.5))

    // sizeAnim = TweenSequence<double>(<TweenSequenceItem<double>>[
    //   TweenSequenceItem<double>(
    //       tween: Tween<double>(begin: 50, end: 100), weight: 0.8),
    //   TweenSequenceItem<double>(
    //       tween: Tween<double>(begin: 100, end: 80), weight: 0.2),
    // ]).animate(_controller);

    //boundの動きとかはCurvesで調整するのがよさそう
    //でもボタンをプルプルさせるような細かい連動は、sequenceが必要か...
    sizeAnim = Tween<double>(begin: 50, end: 80).animate(
        // new CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
        new CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
  }

  // Widget build(BuildContext context) {
  //   return AnimatedBuilder(
  //       //複数のanimation.valueをセットする場合はここはcontrollerを渡す
  //       //animation一つだけの場合はAnimationを渡せばOK
  //       animation: _controller,
  //       builder: (context, _) {
  //         return GestureDetector(
  //             onTap: () {
  //               _controller.forward();
  //             },
  //             child: Container(
  //               // color: _animColor.value,
  //               color: colorAnim.value,
  //               padding: EdgeInsets.all(paddingAnim.value),
  //               child: Text("foo"),
  //             ));
  //       });
  // }

  Widget build(BuildContext context) {
    return AnimatedBuilder(
        //複数のanimation.valueをセットする場合はここはcontrollerを渡す
        //animation一つだけの場合はAnimationを渡せばOK
        animation: _controller,
        builder: (context, _) {
          return GestureDetector(
            onTap: () {
              _controller.forward();
            },
            child: Icon(Icons.favorite,
                color: colorAnim.value, size: sizeAnim.value),
          );
        });
  }
}
