import 'package:chat_app/common/widgets/error.dart';
import 'package:chat_app/common/widgets/loader.dart';
import 'package:chat_app/features/auth/controller/authh_controller.dart';
import 'package:chat_app/features/landing/screens/landing_screen.dart';
import 'package:chat_app/router.dart';
import 'package:chat_app/screens/mobile_layout_screen.dart';
import 'package:chat_app/screens/web_layout_screen.dart';
import 'package:chat_app/utils/responsive_layout.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'colors.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,

  );
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Whatsapp UI',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
      ),
      onGenerateRoute: (settings)=>generateRoute(settings),
      home: ref.watch(userDataAuthProvider).when(data: (user){
        if(user == null){return const LandingScreen();}
        return const MobileLayoutScreen();
      }, error:(error, stackTrace) {
        return ErrorScreen(error: error.toString());
      }, loading: ()=>const Loader(),
      ));

  }
}
