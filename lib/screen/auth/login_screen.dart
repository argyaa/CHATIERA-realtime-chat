import 'package:chat_app/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../cubit/page_cubit.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    handleLogin() {
      context.read<AuthCubit>().signInWithGoogle();
      context.read<PageCubit>().setPage(0);
    }

    buttonLoading() {
      return ElevatedButton(
          onPressed: null,
          style: ElevatedButton.styleFrom(
              primary: Colors.red[900],
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12))),
          child: const Center(
            child: CircularProgressIndicator(),
          ));
    }

    buttonLogin() {
      return ElevatedButton(
        onPressed: handleLogin,
        style: ElevatedButton.styleFrom(
            primary: Colors.red[900],
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12))),
        child: Row(
          children: [
            Image.asset('assets/logo_google.png', height: 50, width: 50),
            const SizedBox(width: 16),
            Text(
              "Sign in with Google",
              style: GoogleFonts.dmSans(fontSize: 16),
            ),
          ],
        ),
      );
    }

    return Scaffold(
        body: SafeArea(
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 280,
                height: 280,
                child: Lottie.asset('assets/login.json'),
              ),
              const SizedBox(height: 150),
              BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is AuthSuccess) {
                    Get.offAllNamed('/main');
                  } else if (state is AuthFailed) {
                    Get.snackbar("Error !", state.error);
                  }
                },
                builder: (context, state) {
                  if (state is AuthLoading) return buttonLoading();
                  return buttonLogin();
                },
              ),
              const SizedBox(height: 50),
              const Text("Chat app"),
              const Text("v.1.0"),
            ],
          ),
        ),
      ),
    ));
  }
}
