


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

void savedatatocontactssubcollection(UserModel senderusermodel,
    UserModel reciverusermodel,String text,DateTime timesent,
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
void sendtextmessage({required BuildContext context,required String text,required String  reciveruserid,required UserModel senderuser
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
await firestore.collection('users').doc(reciveruserid).collection('messages').doc(auth.currentUser!.uid).set(message.toMap()); }



}