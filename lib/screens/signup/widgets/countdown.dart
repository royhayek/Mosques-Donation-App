import 'package:flutter/material.dart';

class Countdown extends AnimatedWidget {
  final Animation<int> animation;

  Countdown({Key key, this.animation}) : super(key: key, listenable: animation);

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);

    String timerText =
        '${clockTimer.inMinutes.remainder(60).toString()}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';

    // print('animation.value  ${animation.value} ');
    // print('inMinutes ${clockTimer.inMinutes.toString()}');
    // print('inSeconds ${clockTimer.inSeconds.toString()}');
    // print(
    //     'inSeconds.remainder ${clockTimer.inSeconds.remainder(60).toString()}');

    return animation.value != 0
        ? Text(
            "$timerText",
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).primaryColor,
            ),
          )
        : Container();
  }
}
