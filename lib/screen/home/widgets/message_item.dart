import 'package:chat_app/cubit/chat_cubit.dart';
import 'package:chat_app/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageItem extends StatelessWidget {
  final DateTime? time;
  final String messageId, friendId;
  final bool isRead, isSender;
  final String? image, name, message;
  final int? count;
  const MessageItem({
    Key? key,
    required this.messageId,
    required this.friendId,
    required this.isRead,
    required this.isSender,
    this.count,
    this.image,
    this.time,
    this.message,
    this.name,
  }) : super(key: key);

  String dateFormat(DateTime time) => DateFormat("dd/MM/yyyy").format(time);
  String timeFormat(DateTime time) => DateFormat("hh:mm").format(time);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      // The end action pane is the one at the right or the bottom side.
      endActionPane: const ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            // An action can be bigger than the others.
            onPressed: null,
            backgroundColor: Color(0xff47BFED),
            foregroundColor: Colors.white,
            icon: Icons.push_pin,
            label: 'Pin',
          ),
          SlidableAction(
            onPressed: null,
            backgroundColor: Color(0xff47BFED),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          context.read<ChatCubit>().gotoChatRoom(messageId, friendId);
        },
        behavior: HitTestBehavior.translucent,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(image!),
                    radius: 26,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    // width: 220,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name!,
                          style: GoogleFonts.dmSans(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            isRead && isSender
                                ? const Text("✔️")
                                : const SizedBox(),
                            isRead && isSender
                                ? const SizedBox(width: 4)
                                : const SizedBox(),
                            Text(
                              message!,
                              style: GoogleFonts.dmSans(),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        timeFormat(time!).toString(),
                        style: GoogleFonts.dmSans(),
                      ),
                      const SizedBox(height: 6),
                      count! > 0
                          ? Container(
                              padding: count.toString().length > 1
                                  ? const EdgeInsets.all(5)
                                  : const EdgeInsets.all(8),
                              decoration: count.toString().length <= 1
                                  ? BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: blue,
                                    )
                                  : BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: blue,
                                    ),
                              child: Text(
                                count.toString(),
                                style: GoogleFonts.dmSans(
                                    fontSize: 12, color: Colors.white),
                              ),
                            )
                          : const SizedBox()
                    ],
                  )
                ],
              ),
              const SizedBox(height: 14),
              const Divider(
                height: 2,
                thickness: 1,
                color: Color(0xffE2E2E2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
