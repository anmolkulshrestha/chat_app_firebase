import 'package:chat_app/features/auth/controller/authh_controller.dart';
import 'package:chat_app/features/chat/repositories/chat_repositories.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import '../../../common/enums/messages_enums.dart';
import '../../../models/chat_contact.dart';
import '../../../models/message.dart';
final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatrepositoryprovider);
  return ChatRepositoryController(ref: ref, chatrepository: chatRepository);
});
class ChatRepositoryController{
  final ChatRepositories chatrepository;
  final ProviderRef ref;
ChatRepositoryController({required this.ref,required this.chatrepository});
  Stream<List<ChatContact>> chatContacts() {
    return chatrepository.getchatcontacts();
  }

  Stream<List<Message>> chatStream(String recieverUserId) {
    return chatrepository.getChatStream(recieverUserId);
  }
void sendtextmessage(BuildContext context,String text,String reciverid){
  ref.read(userDataAuthProvider).whenData((value) => chatrepository.sendtextmessage(context: context, text: text, reciveruserid: reciverid, senderuser: value!));

}


  void sendFileMessage(
      BuildContext context,
      File file,
      String recieverUserId,
      MessageEnum messageEnum,

      ) {

    ref.read(userDataAuthProvider).whenData(
          (value) => chatrepository.sendFileMessage(
        context: context,
        file: file,
        recieverUserId: recieverUserId,
        senderUserData: value!,
        messageEnum: messageEnum,
        ref: ref,

      ),
    );

  }

}