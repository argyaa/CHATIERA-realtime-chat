import 'package:chat_app/components/botton_nav_item.dart';
import 'package:chat_app/cubit/page_cubit.dart';
import 'package:chat_app/cubit/theme_cubit.dart';
import 'package:chat_app/screen/home/call_screen.dart';
import 'package:chat_app/screen/home/message_screen.dart';
import 'package:chat_app/screen/home/status_screen.dart';
import 'package:chat_app/screen/home/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

import '../cubit/auth_cubit.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    print(GetStorage().read('isDarkMode'));
    context.read<ThemeCubit>().getThemeMode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeCubit>().state;

    customBottonNav() {
      return BottomAppBar(
        clipBehavior: Clip.antiAlias,
        child: Container(
          color: isDarkMode ? const Color(0xff1B2430) : Colors.white,
          height: 60,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                TabItem(
                  icon: "assets/icon_chat.png",
                  index: 0,
                ),
                TabItem(
                  icon: "assets/icon_status.png",
                  index: 1,
                ),
                TabItem(
                  icon: "assets/icon_call.png",
                  index: 2,
                ),
                TabItem(
                  icon: "assets/icon_setting.png",
                  index: 3,
                ),
              ]),
        ),
      );
    }

    chatAppBar() {
      return AppBar(
        backgroundColor: isDarkMode ? const Color(0xff1B2430) : Colors.white,
        toolbarHeight: 70,
        flexibleSpace: Container(
          margin: const EdgeInsets.fromLTRB(24, 60, 24, 0),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset(
                    "assets/icon_camera.png",
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(width: 105),
                  Text(
                    "Message",
                    style: GoogleFonts.dmSans(fontSize: 18),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    handleLogout() async {
      await context.read<AuthCubit>().logout();
      Get.offAllNamed('/login');
    }

    settingAppBar() {
      return AppBar(
        backgroundColor: isDarkMode ? const Color(0xff1B2430) : Colors.white,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: handleLogout,
              icon: const Icon(
                Icons.logout,
                color: Color.fromARGB(255, 208, 36, 53),
              ))
        ],
      );
    }

    buildAppBar(int index) {
      switch (index) {
        case 0:
          return chatAppBar();
        case 3:
          return settingAppBar();
      }
    }

    chatFloatingActionButton() {
      return FloatingActionButton(
        onPressed: () {
          Get.toNamed('/search-people');
        },
        child: const Icon(Icons.search),
      );
    }

    buildFloatingActionButton(int index) {
      switch (index) {
        case 0:
          return chatFloatingActionButton();
      }
    }

    buildContent(int index) {
      switch (index) {
        case 0:
          return const MessageScreen();
        case 1:
          return const StatusScreen();
        case 2:
          return const CallScreen();
        case 3:
          return const SettingScreen();
        default:
          return const MessageScreen();
      }
    }

    return BlocBuilder<PageCubit, int>(
      builder: (context, state) {
        return Scaffold(
          appBar: buildAppBar(state),
          body: buildContent(state),
          floatingActionButton: buildFloatingActionButton(state),
          bottomNavigationBar: customBottonNav(),
        );
      },
    );
  }
}
