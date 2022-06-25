import 'dart:io';

import 'package:chat_app/cubit/auth_cubit.dart';
import 'package:chat_app/cubit/select_image_cubit.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../cubit/theme_cubit.dart';

class ChangeProfileScreen extends StatefulWidget {
  final UserModel user;
  const ChangeProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ChangeProfileScreen> createState() => _ChangeProfileScreenState();
}

class _ChangeProfileScreenState extends State<ChangeProfileScreen> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();

  @override
  void initState() {
    _namaController.text = widget.user.displayName.toString();
    _statusController.text = widget.user.status.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeCubit>().state;

    appBar() {
      return AppBar(
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Color(0xffF3F3F9),
            )),
        title: Text(
          "Update Profile",
          style: GoogleFonts.dmSans(
              fontSize: 20,
              color: isDarkMode ? Color(0xffF3F3F9) : Colors.black45),
        ),
        backgroundColor: isDarkMode ? const Color(0xff1B2430) : blue,
      );
    }

    profile() {
      return Column(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.user.photoUrl.toString()),
            radius: 100,
          ),
          const SizedBox(height: 60),
          TextField(
            controller: _namaController,
            cursorColor: isDarkMode ? Colors.white : Colors.black,
            decoration: const InputDecoration(
              labelText: "Nama",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              contentPadding: EdgeInsets.all(15),
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _statusController,
            cursorColor: isDarkMode ? Colors.white : Colors.black,
            decoration: const InputDecoration(
              labelText: "Status",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              contentPadding: EdgeInsets.all(15),
            ),
          ),
        ],
      );
    }

    buttonLoading() {
      return SizedBox(
        width: double.infinity,
        height: 45,
        child: ElevatedButton(
            onPressed: null,
            style: ElevatedButton.styleFrom(
                primary: blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                )),
            child: const Center(child: CircularProgressIndicator())),
      );
    }

    buttonUpdate() {
      return SizedBox(
        width: double.infinity,
        height: 45,
        child: BlocBuilder<SelectImageCubit, SelectImageState>(
          builder: (context, state) {
            if (state is SelectImageSuccess) {
              return ElevatedButton(
                onPressed: () {
                  context.read<AuthCubit>().updateProfileUser(
                        widget.user.id.toString(),
                        _namaController.text,
                        _statusController.text,
                        imagePath: state.data.path,
                      );
                  context.read<SelectImageCubit>().clearImage();
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                    primary: blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    )),
                child: Text(
                  "Update",
                  style: GoogleFonts.dmSans(fontSize: 16),
                ),
              );
            }
            return ElevatedButton(
              onPressed: () {
                context.read<AuthCubit>().updateProfileUser(
                      widget.user.id.toString(),
                      _namaController.text,
                      _statusController.text,
                    );
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                  primary: blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  )),
              child: Text(
                "Update",
                style: GoogleFonts.dmSans(fontSize: 16),
              ),
            );
          },
        ),
      );
    }

    return Scaffold(
      appBar: appBar(),
      body: Container(
        margin: const EdgeInsets.all(24),
        child: ListView(
          children: [
            profile(),
            const SizedBox(height: 24),
            Row(
              children: [
                BlocBuilder<SelectImageCubit, SelectImageState>(
                  builder: (context, state) {
                    if (state is SelectImageSuccess) {
                      return Row(
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: FileImage(File(state.data.path)))),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            state.data.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      );
                    }
                    return Text(
                      "No Image",
                      style: GoogleFonts.dmSans(fontSize: 16),
                    );
                  },
                ),
                const Spacer(),
                BlocBuilder<SelectImageCubit, SelectImageState>(
                  builder: (context, state) {
                    if (state is SelectImageSuccess) {
                      return IconButton(
                          onPressed: () {
                            context.read<SelectImageCubit>().clearImage();
                          },
                          icon: const Icon(Icons.close));
                    }
                    return TextButton(
                        onPressed: () {
                          context.read<SelectImageCubit>().selectImage();
                        },
                        child: Text(
                          "choose Image",
                          style: GoogleFonts.dmSans(
                            color: Colors.white,
                          ),
                        ));
                  },
                )
              ],
            ),
            const SizedBox(height: 24),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state is AuthLoading) return buttonLoading();
                return buttonUpdate();
              },
            )
          ],
        ),
      ),
    );
  }
}
