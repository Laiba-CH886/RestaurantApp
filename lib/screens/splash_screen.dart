import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kkgfrontend/screens/auth/login_screen.dart';
import 'package:kkgfrontend/screens/auth/signup_screen.dart';
import 'package:kkgfrontend/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    // Initialize video controller
    _controller = VideoPlayerController.asset('assets/KKG.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(false);

        // Listen for when video finishes
        _controller.addListener(() {
          if (_controller.value.position >= _controller.value.duration) {
            navigateToNextScreen();
          }
        });
      });

    // Safety timer in case the video fails to play
    Timer(Duration(seconds: 5), () {
      if (mounted && !_controller.value.isPlaying) {
        navigateToNextScreen();
      }
    });
  }

  // Determine the next screen
  void navigateToNextScreen() {
    final User? user = FirebaseAuth.instance.currentUser;

    if (mounted) {
      if (user != null) {
        // ✅ User is already logged in → Go directly to HomeScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen()),
        );
      } else {
        // ❌ No user → Show SignupScreen first
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => SignupScreen()),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the video controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        )
            : CircularProgressIndicator(),
      ),
    );
  }
}
