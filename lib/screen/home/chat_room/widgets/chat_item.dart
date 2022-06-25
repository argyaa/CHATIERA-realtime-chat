import 'package:chat_app/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../cubit/theme_cubit.dart';

class ChatItem extends StatelessWidget {
  final String message;
  final bool isSender;
  final bool? isRead;
  final DateTime? time;

  const ChatItem(
      {Key? key,
      required this.isSender,
      required this.isRead,
      required this.message,
      required this.time})
      : super(key: key);

  String dateFormat(DateTime time) => DateFormat("dd/MM/yyyy").format(time);
  String timeFormat(DateTime time) => DateFormat("hh:mm").format(time);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeCubit>().state;

    return Container(
      child: Row(
        mainAxisAlignment:
            isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment:
                isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.6,
                ),
                margin: isSender
                    ? const EdgeInsets.symmetric(horizontal: 8, vertical: 8)
                    : const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: isSender ? blue : const Color(0xffF2F2F2),
                    borderRadius: BorderRadius.only(
                      topLeft: !isSender
                          ? const Radius.circular(0)
                          : const Radius.circular(12),
                      topRight: isSender
                          ? const Radius.circular(0)
                          : const Radius.circular(12),
                      bottomLeft: const Radius.circular(12),
                      bottomRight: const Radius.circular(12),
                    )),
                child: Column(
                  crossAxisAlignment: isSender
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Text(
                      message,
                      style: GoogleFonts.dmSans(
                          fontSize: 16,
                          color: isSender ? Colors.white : Colors.black),
                    ),
                  ],
                ),
              ),
              isSender
                  ? Row(
                      children: [
                        Text(
                          timeFormat(time!),
                          style: GoogleFonts.dmSans(
                              fontSize: 12,
                              color:
                                  isDarkMode ? Colors.grey[200] : Colors.black),
                        ),
                        const SizedBox(width: 4),
                        isRead! && isSender
                            ? const Text("✔️")
                            : const SizedBox(),
                        const SizedBox(width: 10),
                      ],
                    )
                  : Row(
                      children: [
                        const SizedBox(width: 24),
                        Text(
                          timeFormat(time!),
                          style: GoogleFonts.dmSans(
                              fontSize: 12,
                              color:
                                  isDarkMode ? Colors.grey[200] : Colors.black),
                        ),
                      ],
                    )
            ],
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}
