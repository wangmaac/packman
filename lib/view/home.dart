import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:packman/view/widgets/tiles.dart';
import '../const/constants.dart';
import 'widgets/enemy.dart';
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
  int enemyStartPosition = 12;

  int playerStartPosition = 166;
  late Timer timer;

  EnemyState myState = EnemyState.start;

  late Direction myDirection;
  Direction playerDirection = Direction.hold;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      enemyMoving();
      playerMoving();
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
                child: GestureDetector(
                  onVerticalDragUpdate: (detail) {
                    if (detail.delta.dy > 0) {
                      playerDirection = Direction.down;
                    } else {
                      playerDirection = Direction.up;
                    }
                  },
                  onHorizontalDragUpdate: (detail) {
                    if (detail.delta.dx > 0) {
                      playerDirection = Direction.right;
                    } else {
                      playerDirection = Direction.left;
                    }
                  },
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columnLine),
                    itemBuilder: (context, index) {
                      if (barriers.contains(index)) {
                        return const TileLine();
                      } else if (index == enemyStartPosition) {
                        return const Enemy();
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

  void enemyMoving() {
    if (myState == EnemyState.moving) {
      switch (myDirection) {
        case Direction.up:
          if (!barriers.contains(enemyStartPosition - columnLine)) {
            setState(() {
              enemyStartPosition -= columnLine;
            });
            decideDirection(d: Direction.down);
          } else {
            myState = EnemyState.block;
          }
          break;
        case Direction.down:
          if (!barriers.contains(enemyStartPosition + columnLine)) {
            setState(() {
              enemyStartPosition += columnLine;
            });
            decideDirection(d: Direction.up);
          } else {
            myState = EnemyState.block;
          }
          break;
        case Direction.left:
          if (!barriers.contains(enemyStartPosition - 1)) {
            setState(() {
              enemyStartPosition--;
            });
            decideDirection(d: Direction.right);
          } else {
            myState = EnemyState.block;
          }
          break;
        case Direction.right:
          if (!barriers.contains(enemyStartPosition + 1)) {
            setState(() {
              enemyStartPosition++;
            });
            decideDirection(d: Direction.left);
          } else {
            myState = EnemyState.block;
          }
          break;
      }
    } else {
      decideDirection();
      myState = EnemyState.moving;
    }
  }

  void playerMoving() {
    if (playerDirection == Direction.right) {
      if (!barriers.contains(playerStartPosition + 1)) {
        setState(() {
          playerStartPosition++;
        });
      }
    }
    if (playerDirection == Direction.left) {
      if (!barriers.contains(playerStartPosition - 1)) {
        setState(() {
          playerStartPosition--;
        });
      }
    }
    if (playerDirection == Direction.up) {
      if (!barriers.contains(playerStartPosition - columnLine)) {
        setState(() {
          playerStartPosition -= columnLine;
        });
      }
    }
    if (playerDirection == Direction.down) {
      if (!barriers.contains(playerStartPosition + columnLine)) {
        setState(() {
          playerStartPosition += columnLine;
        });
      }
    }
  }

  void decideDirection({Direction? d}) {
    List<Direction> direction = [];

    if (!barriers.contains(enemyStartPosition - columnLine)) {
      direction.add(Direction.up);
    }
    if (!barriers.contains(enemyStartPosition + columnLine)) {
      direction.add(Direction.down);
    }
    if (!barriers.contains(enemyStartPosition + 1)) {
      direction.add(Direction.right);
    }
    if (!barriers.contains(enemyStartPosition - 1)) {
      direction.add(Direction.left);
    }

    if (d != null && direction.length > 1) {
      direction.remove(d);
    }
    direction.shuffle();
    myDirection = direction.first;
  }
}
