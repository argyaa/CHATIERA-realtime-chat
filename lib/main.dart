import 'package:chat_app/cubit/select_image_cubit.dart';
import 'package:chat_app/cubit/page_cubit.dart';
import 'package:chat_app/screen/auth/login_screen.dart';
import 'package:chat_app/screen/introduction/onboarding_screen.dart';
import 'package:chat_app/screen/main_screen.dart';
import 'package:chat_app/screen/search_people/search_people_screen.dart';
import 'package:chat_app/screen/splash/splash_screen.dart';
import 'package:chat_app/service/theme_service.dart';
import 'package:chat_app/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'cubit/auth_cubit.dart';
import 'cubit/chat_cubit.dart';
import 'cubit/emoji_cubit.dart';
import 'cubit/message_cubit.dart';
import 'cubit/people_cubit.dart';
import 'cubit/theme_cubit.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PageCubit()),
        BlocProvider(create: (context) => EmojiCubit()),
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => PeopleCubit()),
        BlocProvider(create: (context) => MessageCubit()),
        BlocProvider(create: (context) => ChatCubit()),
        BlocProvider(create: (context) => SelectImageCubit()),
        BlocProvider(create: (context) => ThemeCubit()),
      ],
      child: GetMaterialApp(
        theme: light,
        darkTheme: dark,
        themeMode: ThemeService().getThemeMode(),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/introduction': (context) => const OnBoardingScreen(),
          '/login': (context) => const LoginScreen(),
          '/main': (context) => const MainScreen(),
          '/search-people': (context) => const SearchPeopleScreen(),
        },
      ),
    );
  }
}
