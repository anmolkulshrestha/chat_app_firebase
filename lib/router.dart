

import 'package:chat_app/common/widgets/error.dart';
import 'package:chat_app/features/auth/screens/login_screen.dart';
import 'package:chat_app/features/auth/screens/otp_screen.dart';
import 'package:chat_app/features/auth/screens/user_information_screen.dart';

import 'package:flutter/material.dart';

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
    default:
     return MaterialPageRoute(builder: (context)=>Scaffold(
       body: ErrorScreen(error: "this page not found",),
     ));
  }
}