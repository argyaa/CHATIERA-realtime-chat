import 'package:chat_app/cubit/page_cubit.dart';
import 'package:chat_app/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TabItem extends StatelessWidget {
  final String icon;
  final int index;
  const TabItem({Key? key, required this.icon, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var state = context.watch<PageCubit>().state;

    return GestureDetector(
      onTap: () {
        context.read<PageCubit>().setPage(index);
      },
      behavior: HitTestBehavior.translucent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              icon,
              width: 24,
              color: state == index ? blue : grey,
            ),
          ],
        ),
      ),
    );
  }
}
