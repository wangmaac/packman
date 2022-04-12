import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:packman/view/widgets/gameover.dart';
import 'package:packman/view/widgets/path_black.dart';
import 'package:packman/view/widgets/tiles.dart';

import '../const/constants.dart';
import 'widgets/enemy.dart';
import 'widgets/gamefinish.dart';
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
  Timer? timer;
  Timer? sTimer;
  double second = 0.0;

  double speed = 5.0;
  int gameSpeed = 0;

  late Direction enemyDirection;
  GameState gameState = GameState.game;

  late int enemyStartPosition = 12;
  late int preEnemyPosition = 0;

  int playerStartPosition = 166;
  int prePlayerPosition = 0;

  late EnemyState myState;
  late Direction playerDirection;

  @override
  void initState() {
    setting();
    super.initState();
  }

  @override
  void dispose() {
    if (timer != null) {
      timer!.cancel();
    }
    if (sTimer != null) {
      sTimer!.cancel();
    }
    super.dispose();
  }

  getPoints(int position) {
    if (pathPoint.contains(position)) {
      getPoint.add(position);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('웰리브 League'),
          backgroundColor: Colors.black,
          actions: [
            IconButton(
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: MediaQuery.of(context).size.height / 2,
                        color: Colors.amber,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const Text('Modal BottomSheet'),
                              ElevatedButton(
                                child: const Text('Close BottomSheet'),
                                onPressed: () => Navigator.pop(context),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                icon: const Icon(Icons.smoking_rooms))
          ],
        ),
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Expanded(
              flex: 6,
              child: gameState == GameState.over
                  ? const GameOver()
                  : gameState == GameState.finish
                      ? GameFinish(
                          score: getPoint.length,
                          second: second,
                        )
                      : Padding(
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
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: columnLine),
                                itemBuilder: (context, index) {
                                  if (barriers.contains(index)) {
                                    return const TileLine();
                                  } else if (index == enemyStartPosition) {
                                    if (enemyDirection == Direction.left) {
                                      return Transform(
                                        transform: Matrix4.rotationY(pi),
                                        child: const Enemy(),
                                        alignment: FractionalOffset.center,
                                      );
                                    }
                                    return const Enemy();
                                  } else if (index == playerStartPosition) {
                                    if (playerDirection == Direction.left) {
                                      return Transform(
                                        transform: Matrix4.rotationY(pi),
                                        alignment: FractionalOffset.center,
                                        child: const Player(),
                                      );
                                    } else if (playerDirection ==
                                        Direction.up) {
                                      return Transform.rotate(
                                        angle: pi * -0.5,
                                        child: const Player(),
                                        alignment: FractionalOffset.center,
                                      );
                                    } else if (playerDirection ==
                                        Direction.down) {
                                      return Transform.rotate(
                                        angle: pi * 0.5,
                                        child: const Player(),
                                        alignment: FractionalOffset.center,
                                      );
                                    }
                                    return const Player();
                                  } else {
                                    if (pathPoint.contains(index)) {
                                      return const PathLine();
                                    } else {
                                      return const PathBlack();
                                    }
                                  }
                                },
                                itemCount: columnLine * rowLine,
                              ))),
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  //const Expanded(child: JoyStick()),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Slider.adaptive(
                          value: speed,
                          onChanged: (value) {
                            setState(() {
                              speed = value;
                              getGameSpeed(speed);
                            });
                          },
                          min: 1.0,
                          max: 10.0,
                        ),
                        Text(
                          '${speed.toInt()}',
                          style: const TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  )),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        startButton(),
/*                        Text(
                          '${getPoint.length}점',
                          style: const TextStyle(color: Colors.white),
                        )*/
                      ],
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

  getGameSpeed(double speed) {
    gameSpeed = 600 - (speed.toInt() * 50);
  }

  void setting() {
    enemyStartPosition = 12;
    playerStartPosition = 166;
    getGameSpeed(speed);
    second = 0;
    myState = EnemyState.start;
    enemyDirection = Direction.hold;
    playerDirection = Direction.hold;
    getPoint.clear();
    buildPathPoint();
    getPoint.add(playerStartPosition);
    pathPoint.remove(playerStartPosition);
  }

  void enemyMoving() {
    if (myState == EnemyState.moving) {
      switch (enemyDirection) {
        case Direction.up:
          if (!barriers.contains(enemyStartPosition - columnLine)) {
            setState(() {
              preEnemyPosition = enemyStartPosition;
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
              preEnemyPosition = enemyStartPosition;
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
              preEnemyPosition = enemyStartPosition;
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
              preEnemyPosition = enemyStartPosition;
              enemyStartPosition++;
            });
            decideDirection(d: Direction.left);
          } else {
            myState = EnemyState.block;
          }
          break;
        default:
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
          prePlayerPosition = playerStartPosition;
          playerStartPosition++;
          getPoints(playerStartPosition);
          pathPoint.remove(playerStartPosition);
        });
      }
    }
    if (playerDirection == Direction.left) {
      if (!barriers.contains(playerStartPosition - 1)) {
        setState(() {
          prePlayerPosition = playerStartPosition;
          playerStartPosition--;
          getPoints(playerStartPosition);
          pathPoint.remove(playerStartPosition);
        });
      }
    }
    if (playerDirection == Direction.up) {
      if (!barriers.contains(playerStartPosition - columnLine)) {
        setState(() {
          prePlayerPosition = playerStartPosition;
          playerStartPosition -= columnLine;
          getPoints(playerStartPosition);
          pathPoint.remove(playerStartPosition);
        });
      }
    }
    if (playerDirection == Direction.down) {
      if (!barriers.contains(playerStartPosition + columnLine)) {
        setState(() {
          prePlayerPosition = playerStartPosition;
          playerStartPosition += columnLine;
          getPoints(playerStartPosition);
          pathPoint.remove(playerStartPosition);
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
    enemyDirection = direction.first;
  }

  void buildPathPoint() {
    pathPoint.clear();
    for (int i = 0; i < (columnLine * rowLine) - 1; i++) {
      if (!barriers.contains(i)) {
        pathPoint.add(i);
      }
    }
  }

  void runTime() {
    sTimer =
        Timer.periodic(const Duration(milliseconds: 10), (timer) => second++);

    timer = Timer.periodic(Duration(milliseconds: gameSpeed), (timer) {
      if (pathPoint.isEmpty) {
        endTime();
        setState(() {
          gameState = GameState.finish;
        });
      }

      if (collision()) {
        endTime();
        setState(() {
          gameState = GameState.over;
        });
      } else {
        enemyMoving();
        playerMoving();
      }
    });
  }

  void endTime() {
    if (timer != null) {
      timer!.cancel();
    }
    if (sTimer != null) {
      sTimer!.cancel();
    }
  }

  bool collision() {
    if (prePlayerPosition == enemyStartPosition &&
        preEnemyPosition == playerStartPosition) {
      return true;
    } else if (playerStartPosition == enemyStartPosition) {
      return true;
    }
    return false;
  }

  Widget startButton() {
    return OutlinedButton(
      onPressed: () {
        gameState = GameState.game;
        setting();
        endTime();
        runTime();
      },
      style: ButtonStyle(
          fixedSize: MaterialStateProperty.all<Size>(const Size.fromHeight(50)),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white)),
      child: Text(
        'START',
        style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.08),
      ),
    );
  }
}
