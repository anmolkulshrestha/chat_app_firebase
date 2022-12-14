

import 'package:chat_app/common/widgets/error.dart';
import 'package:chat_app/features/auth/screens/login_screen.dart';
import 'package:chat_app/features/auth/screens/otp_screen.dart';
import 'package:chat_app/features/auth/screens/user_information_screen.dart';
import 'package:chat_app/features/chat/screens/mobile_chat_screen.dart';

import 'package:flutter/material.dart';

import 'features/selectcontacts/screens/select_contacts_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings){
  switch(settings.name){
    case LoginScreen.routeName:
      return MaterialPageRoute(builder: (context)=>const LoginScreen());
    case UserInformationScreen.routeName:
      return MaterialPageRoute(builder: (context)=>const UserInformationScreen());


    case OTPScreen.routeName:
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => OTPScreen(
          verificationId: verificationId,
        ),
      );
    case SelectContactsScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SelectContactsScreen(),
      );
    case MobileChatScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final name = arguments['name'];
      final uid = arguments['uid'];

      return MaterialPageRoute(
        builder: (context) => MobileChatScreen(
          name: name,
          uid: uid,

        ),
      );
    default:
     return MaterialPageRoute(builder: (context)=>Scaffold(
       body: ErrorScreen(error: "this page not found",),
     ));
  }
}