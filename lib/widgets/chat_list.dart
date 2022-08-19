import 'package:chat_app/features/chat/controllers/chat_controller.dart';
import 'package:chat_app/widgets/sender_message_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../info.dart';
import 'my_message_card.dart';


class ChatList extends ConsumerWidget {
  final String reciveruserid;
  const ChatList({Key? key,required this.reciveruserid}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return StreamBuilder(
stream:ref.read(chatControllerProvider).chatStream(this.reciveruserid),
      builder:(context, snapshot) {
        return ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            if (messages[index]['isMe'] == true) {
              return MyMessageCard(
                message: messages[index]['text'].toString(),
                date: messages[index]['time'].toString(),
              );
            }
            return SenderMessageCard(
              message: messages[index]['text'].toString(),
              date: messages[index]['time'].toString(),
            );
          },
        );
      }

    );
  }
}
