import 'package:chat_app/features/auth/controller/authh_controller.dart';
import 'package:chat_app/features/chat/widgets/bottom_chat_field.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../colors.dart';
import '../../../info.dart';
import '../../../widgets/chat_list.dart';


class MobileChatScreen extends ConsumerWidget {
  static const String routeName = '/mobile-chat-screen';
  final String name;
  final String uid;
  const MobileChatScreen({Key? key,required this.name,required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: StreamBuilder<UserModel>(
        stream: ref.read(authControllerProvider).userDataById(uid),
          builder: (context, snapshot) {
            if(snapshot.connectionState==ConnectionState.done){
              return Column(
                children: [
                  Text(name),
                Text(snapshot.data!.isOnline ? 'online' : 'offline',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.normal,))
                ],
              );
            }
          return Container();

          }),

        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.video_call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),

      body: Column(
        children: [
          const Expanded(
            child: ChatList(),
          ),
          BottamChatField(reciveruserid: uid,)

        ],
      ),
    );
  }


}
