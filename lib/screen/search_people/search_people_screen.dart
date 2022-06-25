import 'package:chat_app/cubit/people_cubit.dart';
import 'package:chat_app/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/theme_cubit.dart';
import '../../models/user_model.dart';

class SearchPeopleScreen extends StatefulWidget {
  const SearchPeopleScreen({Key? key}) : super(key: key);

  @override
  State<SearchPeopleScreen> createState() => _SearchPeopleScreenState();
}

class _SearchPeopleScreenState extends State<SearchPeopleScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeCubit>().state;

    appBar() {
      return PreferredSize(
        preferredSize: const Size.fromHeight(140),
        child: AppBar(
          backgroundColor: isDarkMode ? const Color(0xff1B2430) : blue,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: isDarkMode ? const Color(0xffF3F3F9) : Colors.black,
              )),
          title: Text(
            "Search People",
            style:
                TextStyle(color: isDarkMode ? Colors.grey[200] : Colors.black),
          ),
          centerTitle: true,
          flexibleSpace: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
              child: TextField(
                onChanged: (val) {
                  context.read<PeopleCubit>().searchPeople(val);
                },
                controller: _searchController,
                cursorColor: isDarkMode ? Colors.white : Colors.black,
                decoration: InputDecoration(
                    fillColor: isDarkMode
                        ? const Color(0xff2a384a)
                        : const Color(0xffF2F2F2),
                    filled: true,
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        )),
                    hintText: "Search new people",
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    suffixIcon: const Icon(Icons.search)),
              ),
            ),
          ),
        ),
      );
    }

    listPeople(List<UserModel> user) {
      return Column(
          children: user
              .map((e) => ListTile(
                    leading: CircleAvatar(
                      radius: 26,
                      backgroundImage: NetworkImage(e.photoUrl.toString()),
                    ),
                    title: Text(
                      e.displayName.toString(),
                      // name.length > 24 ? name.substring(0, 24) + "..." : name,
                      style: GoogleFonts.dmSans(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      e.email.toString(),
                      // name.length > 24 ? name.substring(0, 24) + "..." : name,
                      style: GoogleFonts.dmSans(),
                    ),
                    trailing: GestureDetector(
                      onTap: () async {
                        await context
                            .read<PeopleCubit>()
                            .addNewConnection(e.id.toString());
                      },
                      child: const Chip(label: Text("Message")),
                    ),
                  ))
              .toList());
    }

    noData() {
      return const Center(
        child: Text("no data"),
      );
    }

    loadingData() {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      appBar: appBar(),
      body: ListView(
        // padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
        children: [
          BlocBuilder<PeopleCubit, PeopleState>(
            builder: (context, state) {
              if (state is PeopleSuccess) {
                if (state.user.isEmpty) return noData();
                return listPeople(state.user);
              }
              return loadingData();
            },
          ),
        ],
      ),
    );
  }
}
