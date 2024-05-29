import 'package:flutter/material.dart';
import 'package:printa/view/on_boarding/on_boarding.dart';
import 'dart:math';

import '../../shared/components/components.dart';

class CustomSplashScreen extends StatefulWidget {
  @override
  _CustomSplashScreenState createState() => _CustomSplashScreenState();
}

class _CustomSplashScreenState extends State<CustomSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoAnimation;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3), // Set your desired animation duration
    );

    _logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    _textAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    _controller.forward().whenComplete(() {
      navigateAndFinish(context, on_boarding());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          // Image.asset(
          //   'images/Splash.jpg',
          //   fit: BoxFit.cover,
          // ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _logoAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _logoAnimation.value,
                      child: Transform.rotate(
                        angle: _logoAnimation.value * 2 * pi, // Rotate the logo
                        child: YourLogoWidget(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),
                AnimatedBuilder(
                  animation: _textAnimation,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _textAnimation,
                      child: Text(
                        'Prenta',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SoulDaisy',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class YourLogoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Replace this with your logo or custom widget
    return Image.asset(
      'images/Prenta.png',
      width: 200, // Specify the desired width
      height: 200, // Specify the desired height
      fit: BoxFit.contain, // Choose an appropriate fit option
    );
  }
}
