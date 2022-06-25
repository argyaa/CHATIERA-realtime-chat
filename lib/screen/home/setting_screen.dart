import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/cubit/auth_cubit.dart';
import 'package:chat_app/cubit/theme_cubit.dart';
import 'package:chat_app/screen/home/setting/change_profile_screen.dart';
import 'package:chat_app/service/theme_service.dart';
import 'package:chat_app/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/user_model.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  var pref = GetStorage();

  @override
  Widget build(BuildContext context) {
    profileUser(UserModel user) {
      return Container(
        margin: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: user.photoUrl.toString(),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(user.displayName.toString(),
                style: GoogleFonts.dmSans(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 4,
            ),
            Text("\"${user.status.toString()}\"",
                style: GoogleFonts.dmSans(fontSize: 16)),
            const SizedBox(
              height: 4,
            ),
            Text(user.email.toString())
          ],
        ),
      );
    }

    settings() {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            // ListTile(
            //   onTap: () {
            //     Get.toNamed('/update-status');
            //   },
            //   leading: const Icon(Icons.note_alt),
            //   title: Text("Update Status",
            //       style: GoogleFonts.dmSans(fontSize: 18)),
            //   trailing: const Icon(Icons.arrow_right),
            // ),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state is AuthSuccess) {
                  return ListTile(
                    onTap: () {
                      Get.to(ChangeProfileScreen(
                        user: state.user,
                      ));
                    },
                    leading: const Icon(Icons.person),
                    title: Text("Update Profile",
                        style: GoogleFonts.dmSans(fontSize: 18)),
                    trailing: const Icon(Icons.arrow_right),
                  );
                }
                return ListTile(
                  onTap: null,
                  leading: const Icon(Icons.person),
                  title: Text("Update Profile",
                      style: GoogleFonts.dmSans(fontSize: 18)),
                  trailing: const Icon(Icons.arrow_right),
                );
              },
            ),
            SwitchListTile(
              secondary: const Icon(Icons.color_lens),
              title: Text("Dark Mode", style: GoogleFonts.dmSans(fontSize: 18)),
              value: ThemeService().isSavedDarkMode(),
              onChanged: (bool val) {
                // print(val);
                // setState(() {
                //   pref.write('isDarkMode', val);
                //   print("storage ${pref.read('isDarkMode')} ");
                // });

                // Get.changeThemeMode(
                //     pref.read('isDarkMode') ? ThemeMode.dark : ThemeMode.light);
                setState(() {
                  ThemeService().changeThemeMode();
                  context.read<ThemeCubit>().changeThemeMode();
                });
              },
            ),
          ],
        ),
      );
    }

    versionApp() {
      return Container(
        child: Column(
          children: const [
            Text("Chat App"),
            Text("v.1.0"),
          ],
        ),
      );
    }

    loadingUserInfo() {
      return Container(
        margin: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[350],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              color: Colors.grey[350],
              child: Text("user.displayName.toString()",
                  style: GoogleFonts.dmSans(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[350],
                  )),
            ),
            const SizedBox(
              height: 4,
            ),
            Container(
              color: Colors.grey[350],
              child: Text("user.status.toString()",
                  style: GoogleFonts.dmSans(
                    fontSize: 16,
                    color: Colors.grey[350],
                  )),
            ),
            const SizedBox(
              height: 4,
            ),
            Container(
              color: Colors.grey[350],
              child: Text(
                "user.email.toString()",
                style: TextStyle(
                  color: Colors.grey[350],
                ),
              ),
            )
          ],
        ),
      );
    }

    return ListView(
      children: [
        BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthSuccess) return profileUser(state.user);
            return loadingUserInfo();
          },
        ),
        settings(),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.15,
        ),
        versionApp(),
      ],
    );
  }
}
