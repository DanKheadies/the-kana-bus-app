import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController aniCont;
  late Timer navTimer;

  @override
  void initState() {
    super.initState();

    aniCont = AnimationController(
        duration: const Duration(seconds: 2),
        vsync: this,
      )
      ..forward().then((_) {
        aniCont.reverse();
      });

    animation = CurvedAnimation(parent: aniCont, curve: Curves.fastOutSlowIn);

    navTimer = Timer(
      const Duration(seconds: 4),
      () => context.goNamed('kanaBus'),
    );
  }

  @override
  void dispose() {
    aniCont.dispose();
    navTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Title(
      title: 'The Kana Bus',
      color: Colors.deepPurple,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: InkWell(
          onTap: () {
            navTimer.cancel();
            context.goNamed('kanaBus');
          },
          child: Center(
            child: ScaleTransition(
              scale: animation,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image(
                  image: AssetImage('assets/images/splash/launch.png'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
