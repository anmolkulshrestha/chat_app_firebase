


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/common/utils/utils.dart';
import 'package:chat_app/features/auth/screens/otp_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
final authRepositoryProvider = Provider(
      (ref) => AuthRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  ),
);
class AuthRepository{
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepository({required this.auth,required this.firestore});
  Future<void> signInWithPhone(BuildContext context,String phonenumber) async{

 try{
   print("called");
   await auth.verifyPhoneNumber(phoneNumber:phonenumber,verificationCompleted: (PhoneAuthCredential credential) async{
     print("hhhhhhhhhhhhhhuuuuuiiiiii");
await auth.signInWithCredential(credential);
print("hhhhhhhhhhhhhhuuuuu");
   }, verificationFailed: (e){
     print("failedfailedfailed1");
     throw Exception(e.message);

   }, codeSent: ((String verificationId,int? resendToken) async{
     Navigator.pushNamed(
       context,
       OTPScreen.routeName,
       arguments: verificationId,
     );
   }), codeAutoRetrievalTimeout: (String verificationId){});
  } on FirebaseAuthException
  catch(e){
    print("hhhhhhhhhhhhhh22222");
showSnackBar(context: context, content: e.toString());
  }
  }
  void verifyOTP({
    required BuildContext context,
    required String verificationId,
    required String userOTP,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: userOTP,
      );
      await auth.signInWithCredential(credential);

    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

}