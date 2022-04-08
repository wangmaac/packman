import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../view/home.dart';

class Application extends StatelessWidget {
  const Application({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GoRouter _goRouter = GoRouter(routes: [
      GoRoute(path: '/', builder: (context, state) => const Home()),
    ]);
    return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routeInformationParser: _goRouter.routeInformationParser,
        routerDelegate: _goRouter.routerDelegate);
  }
}
