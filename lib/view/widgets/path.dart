import 'package:flutter/material.dart';

class PathLine extends StatelessWidget {
  const PathLine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(1.5),
      child: Center(
        child: Container(
          width: 10,
          decoration:
              const BoxDecoration(shape: BoxShape.circle, color: Colors.yellow),
        ),
      ),
    );
  }
}
