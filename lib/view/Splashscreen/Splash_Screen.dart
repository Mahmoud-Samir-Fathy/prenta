import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:video_player/video_player.dart';
import 'package:printa/view/on_boarding/on_boarding.dart';
import 'package:printa/view/login&register_screen/account_screen/account_screen.dart';
import 'package:printa/view/layout/prenta_layout.dart';

class SplashScreen extends StatefulWidget {
  final bool? onBoarding;
  final String? uId;
  final bool? isDark;
  SplashScreen({this.onBoarding, this.uId,this.isDark});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoAnimation;
  late Animation<double> _textAnimation;
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    _logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _textAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    _videoController = VideoPlayerController.asset('images/background.mp4')
      ..initialize().then((_) {
        _videoController.setLooping(true);
        _videoController.play();
        setState(() {});
      });

    _controller.forward().whenComplete(() {
      Widget startWidget;
      if (widget.onBoarding != null) {
        if (widget.uId != null) {
          startWidget = PrentaLayout();
        } else {
          startWidget = AccountScreen();
        }
      } else {
        startWidget = OnBoarding();
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => startWidget),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          _videoController.value.isInitialized
              ? VideoPlayer(_videoController)
              : Container(color: Colors.black),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _logoAnimation,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _logoAnimation,
                      child: YourLogoWidget(),
                    );
                  },
                ),
                SizedBox(height: 20),
                Text(
                  'Prenta',
                  style: TextStyle(
                    color: HexColor('#27374D'),
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SoulDaisy',
                  ),
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
    return Image.asset(
      'images/Prenta.png',
      width: 200,
      height: 200,
      fit: BoxFit.contain,
    );
  }
}
