import 'package:flutter/material.dart';

class JoyStick extends StatefulWidget {
  const JoyStick({Key? key}) : super(key: key);

  @override
  State<JoyStick> createState() => _JoyStickState();
}

class _JoyStickState extends State<JoyStick>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  late Offset currentOffset;
  late Animation<Offset> _animation;

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    currentOffset = initSetting(0.0, 0.0);
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100));

    super.initState();
  }

  Offset initSetting(double left, double right) {
    return Offset(left, right);
  }

  @override
  Widget build(BuildContext context) {
    _animation = Tween(begin: Offset(0, 0), end: currentOffset)
        .animate(animationController);
    return GestureDetector(
      child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.translate(
              offset: _animation.value,
              child: child,
            );
          },
          child: CircleAvatar(
            backgroundColor: Colors.grey.shade700,
          )),
      onPanUpdate: (_) {
        setState(() {
          //currentOffset = currentOffset + Offset(_.delta.dx, _.delta.dy);

          currentOffset = currentOffset.translate(_.delta.dx, _.delta.dy);
        });
        animationController.forward();
      },
      onPanEnd: (_) {
        setState(() {
          currentOffset = Offset(0, 0);
        });
      },
    );
/*    return LayoutBuilder(
      builder: (context, constrains) {
        return Center(
          child: Container(
            decoration:
                const BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
            child: CircleAvatar(),
          ),
        );
      },
    );*/
  }
}
