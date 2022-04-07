import 'package:flutter/material.dart';

class TileLine extends StatelessWidget {
  const TileLine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(width: 0.2, color: Colors.grey),
        color: Colors.blue[800],
      ),
    );
  }
}
