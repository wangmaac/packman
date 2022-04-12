import 'package:flutter/material.dart';

class GameFinish extends StatelessWidget {
  final int score;
  final double second;
  const GameFinish({Key? key, required this.score, required this.second})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //service something
    return DefaultTextStyle(
      style: const TextStyle(color: Colors.white, fontSize: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('축하합니다.'),
          Text('score : $score'), //no mean this score
          Text('time : ${second / 100}'),
        ],
      ),
    );
  }
}
