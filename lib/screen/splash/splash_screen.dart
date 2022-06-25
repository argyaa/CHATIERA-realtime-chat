import 'package:chat_app/cubit/auth_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var pref = GetStorage();

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));

    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        if (pref.hasData('isSkipIntro')) {
          if (_auth.currentUser != null) {
            await context
                .read<AuthCubit>()
                .getCurrentUser(_auth.currentUser!.uid);
            Get.offAllNamed('/main');
          } else {
            Get.offAllNamed("/login");
          }
        } else {
          Get.offAllNamed("/introduction");
        }
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset("assets/chat_splash.json",
            width: 200,
            height: 200,
            controller: _controller, onLoaded: (composition) {
          _controller.forward();
        }),
      ),
    );
  }
}
