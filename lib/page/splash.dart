import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_page.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/images/ic_splash.png",
          width: Get.width,
          height: Get.height,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  void startTimer() {
    Future.delayed(const Duration(seconds: 3), () {
      Get.off(Home());
    });
  }
}
