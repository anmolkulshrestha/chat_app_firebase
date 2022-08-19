import 'package:chat_app/features/chat/controllers/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../colors.dart';

class BottamChatField extends ConsumerStatefulWidget {
  final String reciveruserid;
  const BottamChatField({Key? key, required this.reciveruserid}) : super(key: key);

  @override
  ConsumerState<BottamChatField> createState() => _BottamChatFieldState();
}

class _BottamChatFieldState extends ConsumerState<BottamChatField> {
  bool isshowsendbutton=false;
  final TextEditingController texteditincontroller=TextEditingController();
 void sendtextmessage() async{
   if(this.isshowsendbutton){
ref.read(chatControllerProvider).sendtextmessage(context, texteditincontroller.text.trim(), widget.reciveruserid);
   }
 }

  @override
  Widget build(BuildContext context) {
    return Row(

     children: [
       Expanded(
         child: TextField(
           controller: texteditincontroller,
    decoration: InputDecoration(
      filled: true,
      fillColor: mobileChatBoxColor,
      prefixIcon: const SizedBox(
          width: 100,
         child: Icon(Icons.emoji_emotions, color: Colors.grey,)

    ),

        suffixIcon: SizedBox(
          width: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Icon(Icons.camera_alt, color: Colors.grey,),
              Icon(Icons.attach_file, color: Colors.grey,),
              Icon(Icons.money, color: Colors.grey,),
            ],
          ),
      ),
      hintText: 'Type a message!',
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
      ),
      contentPadding: const EdgeInsets.all(10),
    ),),
       ),

       Padding(
         padding: EdgeInsets.only(right: 2,
         bottom: 8,
         left: 2),
         child: CircleAvatar(
           backgroundColor: Colors.green,
radius: 25,
           child: GestureDetector(
             child: Icon(
               this.isshowsendbutton?Icons.send:Icons.mic,
               color: Colors.white,
             ),
           ),
         ),
       )
     ]

    );

  }
}
