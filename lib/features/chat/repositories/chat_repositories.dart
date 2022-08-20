


import 'dart:io';

import 'package:chat_app/common/enums/messages_enums.dart';
import 'package:chat_app/common/utils/utils.dart';
import 'package:chat_app/models/chat_contact.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../common/repositories/commonfirebasestoragerepository.dart';


final chatrepositoryprovider=Provider((ref)=>ChatRepositories(firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance));
class ChatRepositories{
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  ChatRepositories({required this.firestore,required this.auth});

  Stream<List<Message>> getChatStream(String recieverUserId) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserId)
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        messages.add(Message.fromMap(document.data()));
      }
      return messages;
    });
  }

void savedatatocontactssubcollection(
    UserModel senderusermodel,
    UserModel reciverusermodel,
    String text,
    DateTime timesent,
    String reciveruserid) async{

    var reciverchatcontact=ChatContact(name: senderusermodel.name, profilePic: senderusermodel.profilePic, contactId: senderusermodel.uid, timeSent:timesent , lastMessage: text);
  await firestore.collection('users').doc(reciveruserid).collection('chats').doc(auth.currentUser!.uid).set(reciverchatcontact.toMap());

  var senderchatcontact=ChatContact(name: reciverusermodel.name, profilePic: reciverusermodel.profilePic, contactId: reciverusermodel.uid, timeSent:timesent , lastMessage: text);
  await firestore.collection('users').doc(auth.currentUser!.uid).collection('chats').doc(reciveruserid).set(senderchatcontact.toMap());

}

Stream<List<ChatContact>> getchatcontacts(){
  return  firestore.collection('users').doc(auth.currentUser!.uid).collection('chats').snapshots().asyncMap((event) async {
    List<ChatContact> contacts=[];
    for(var document in event.docs){
      var chatcontact=ChatContact.fromMap(document.data());
      var userdata=await firestore.collection('users').doc(chatcontact.contactId).get();
      var user=UserModel.fromMap(userdata.data()!);
      contacts.add(ChatContact(name: user.name, profilePic: user.profilePic, contactId: user.uid, timeSent: chatcontact.timeSent, lastMessage: chatcontact.lastMessage));
    }
    return contacts;
  });

}
void sendtextmessage({required BuildContext context,
  required String text,
  required String  reciveruserid,
  required UserModel senderuser
}) async{

try{
var timesent=DateTime.now();
UserModel receiveruserdata;
var messageid=const Uuid().v1();
var Userdatamap=await firestore.collection('users').doc(reciveruserid).get();
receiveruserdata=UserModel.fromMap(Userdatamap.data()!);
savedatatocontactssubcollection(senderuser, receiveruserdata, text, timesent, reciveruserid);
savemessagetomessagesubcollection(messagetype: MessageEnum.text,reciveruserid: reciveruserid,text: text,timesent: timesent,messageid:messageid,reciverusername: receiveruserdata.name,username: senderuser.name );

}catch(e){
  showSnackBar(context: context, content: e.toString());
}
}

  void savemessagetomessagesubcollection({required String reciveruserid,
    required String text,
  required DateTime timesent
    ,required String messageid,
    required String username,
    required String reciverusername,
  required MessageEnum messagetype}) async{
final message=Message(senderId: auth.currentUser!.uid, recieverid: reciveruserid, text: text, type: messagetype, timeSent: timesent, messageId: messageid);

await firestore.collection('users').doc(auth.currentUser!.uid).collection('messages').doc(messageid).set(message.toMap());
await firestore.collection('users').doc(reciveruserid).collection('messages').doc(messageid).set(message.toMap()); }

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required String recieverUserId,
    required UserModel senderUserData,
    required ProviderRef ref,
    required MessageEnum messageEnum,


  }) async {
    try {
      var timeSent = DateTime.now();
      var messageId = const Uuid().v1();

      String imageUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
        'chat/${messageEnum.type}/${senderUserData.uid}/$recieverUserId/$messageId',
        file,
      );

      UserModel? recieverUserData;

        var userDataMap =
        await firestore.collection('users').doc(recieverUserId).get();
        recieverUserData = UserModel.fromMap(userDataMap.data()!);


      String contactMsg;

      switch (messageEnum) {
        case MessageEnum.image:
          contactMsg = '📷 Photo';
          break;
        case MessageEnum.video:
          contactMsg = '📸 Video';
          break;
        case MessageEnum.audio:
          contactMsg = '🎵 Audio';
          break;
        case MessageEnum.gif:
          contactMsg = 'GIF';
          break;
        default:
          contactMsg = 'GIF';
      }
      savedatatocontactssubcollection(
        senderUserData,
        recieverUserData,
        contactMsg,
        timeSent,
        recieverUserId,

      );

savemessagetomessagesubcollection(
        reciveruserid: recieverUserId,
        text: imageUrl,
        timesent: timeSent,
        messageid: messageId,
        username: senderUserData.name,
        messagetype: messageEnum,

        reciverusername: recieverUserData!.name,


      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

}

