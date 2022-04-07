import 'package:flutter/material.dart';

class Enemy extends StatelessWidget {
  const Enemy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'images/enemy.png',
      fit: BoxFit.cover,
    );
  }
}
