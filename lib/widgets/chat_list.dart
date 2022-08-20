import 'package:chat_app/common/widgets/loader.dart';
import 'package:chat_app/features/chat/controllers/chat_controller.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/widgets/sender_message_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../info.dart';
import 'my_message_card.dart';
class ChatList extends ConsumerStatefulWidget {
  final String reciveruserid;
  const ChatList({Key? key,required this.reciveruserid}) : super(key: key);

  @override
  ConsumerState<ChatList> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController scrollcontroller=ScrollController();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
        stream:ref.read(chatControllerProvider).chatStream(widget.reciveruserid),
        builder:(context, snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting){
            return const Loader();
          }
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            scrollcontroller.jumpTo(scrollcontroller.position.maxScrollExtent);
          });
          return ListView.builder(
            controller: scrollcontroller,
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final messagedata=snapshot.data![index];
              if (messagedata.senderId==FirebaseAuth.instance.currentUser!.uid) {
                return MyMessageCard(
                  message: messagedata.text,
                  date: DateFormat.Hm().format(messagedata.timeSent),
                  type: messagedata.type,
                );
              }
              return SenderMessageCard(
                message: messagedata.text,
                date: DateFormat.Hm().format(messagedata.timeSent),
              );
            },
          );
        }

    );
  }
}


