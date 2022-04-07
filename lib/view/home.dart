import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:packman/view/widgets/tiles.dart';

import '../const/constants.dart';
import 'widgets/joystick.dart';
import 'widgets/path.dart';
import 'widgets/player.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int columnLine = 11;
  int rowLine = 17;
  int playerStartPosition = 13;
  String state = 'start';
  late Timer timer;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      /**
       * 1. 처음시작시, 각 방향 정함,
       * 2. 일단 한 방향 이동 막히면
       * 3. 벽마주보는 포지션에서 갈수있는 방향을 정함,
       * 4. 방향을 랜덤으로 정함
       * 5. 다음 지점이 막혀있는지 확인
       * */
      setState(() {
        if (!barriers.contains(playerStartPosition + columnLine)) {
          //up direction possible
        }
        if (!barriers.contains(playerStartPosition - columnLine)) {
          //down direction possible
        }
        if (!barriers.contains(playerStartPosition + 1)) {
          //right direction possible
        }

        if (!barriers.contains(playerStartPosition + 1)) {
          playerStartPosition++;
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columnLine),
                  itemBuilder: (context, index) {
                    if (barriers.contains(index)) {
                      return const TileLine();
                    } else if (index == playerStartPosition) {
                      return const Player();
                    } else {
                      return const PathLine();
                    }
                  },
                  itemCount: columnLine * rowLine,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  const Expanded(child: JoyStick()),
                  Expanded(
                    child: Container(
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
