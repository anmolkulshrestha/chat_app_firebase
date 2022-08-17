import 'dart:io';

import 'package:chat_app/common/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/authh_controller.dart';


class UserInformationScreen extends ConsumerStatefulWidget {

 static const String routeName='/user-information';

  const UserInformationScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends ConsumerState<UserInformationScreen> {
 final TextEditingController nameController = TextEditingController();
 File? image;


 void selectImage() async {
  image = await pickimage(context);
  if(image==null){print("cccccccc");}
  else{print("bjadhakhbvjdbvncnajcbqskjb vkj");}
  setState(() {

  });
 }
 void storeUserData() async {
  String name = nameController.text.trim();

  if (name.isNotEmpty) {
   ref.read(authControllerProvider).saveUserDataToFirebase(
    context,
    name,
    image,
   );
  }
 }

  @override
  Widget build(BuildContext context) {
   final size = MediaQuery.of(context).size;

    return Scaffold(
     body: SafeArea(
      child: Center(
       child: Column(
        children: [
         Stack(
          children: [
           image == null
               ? const CircleAvatar(
            backgroundImage: NetworkImage(
             'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png',
            ),
            radius: 64,
           )
               : CircleAvatar(
            backgroundImage: FileImage(
             image!,
            ),
            radius: 64,
           ),
           Positioned(
            bottom: -10,
            left: 80,
            child: IconButton(
             onPressed: selectImage,
             icon: const Icon(
              Icons.add_a_photo,
             ),
            ),
           ),
          ],
         ),
         Row(
          children: [
           Container(
            width: size.width * 0.85,
            padding: const EdgeInsets.all(20),
            child: TextField(
             controller: nameController,
             decoration: const InputDecoration(
              hintText: 'Enter your name',
             ),
            ),
           ),
           IconButton(
            onPressed: storeUserData,
            icon: const Icon(
             Icons.done,
            ),
           ),
          ],
         ),
        ],
       ),
      ),
     ),
    );
  }
}
