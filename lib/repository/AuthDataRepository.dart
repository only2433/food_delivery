import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_delivery/data/firebase/CheckoutData.dart';
import 'package:get/get.dart';

import '../data/firebase/UserData.dart';

class AuthDataRepository extends GetxService
{
  final FirebaseAuth firebaseAuth;
  AuthDataRepository({required this.firebaseAuth});

  Future<UserCredential> login(String email, String password)
  {
    return firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> logout() async
  {
    firebaseAuth.signOut();
  }

  Future<UserCredential?> signUpAuth(String userEmail, String userPassword) async
  {
    try {
      final user = await firebaseAuth.createUserWithEmailAndPassword(
          email: userEmail,
          password: userPassword);

      return user;
    }
    catch (e) {
      return null;
    }
  }

  Future<bool> uploadToSignUpUserData(String uid, File userImage, UserData data) async
  {
    try
    {
       final refImage = FirebaseStorage.instance
           .ref()
           .child('user_image')
           .child(uid +".png");
       await refImage.putFile(userImage);
       final userImageUrl = await refImage.getDownloadURL();

       await FirebaseFirestore.instance
       .collection('users')
       .doc(uid)
       .set({
         'userName': data.userName,
         'userEmail': data.userEmail,
         'userAddress': data.userAddress,
         'userPhoneNumber': data.userPhoneNumber,
         'userBirthday': data.userBirthday,
         'userImage': userImageUrl
       });

       return true;
    }
    catch(e)
    {
      return false;
    }
  }

  Future<UserData> getUserData() async
  {
    var snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .get();

    if(snapshot.exists)
    {
      return UserData.fromJson(snapshot.data()!);
    }
    else
    {
      throw Exception("No data found");
    }
  }
  
  Future<void> uploadCheckoutData(CheckoutItem data) async
  {
    await FirebaseFirestore.instance
        .collection('checkout')
        .doc(firebaseAuth.currentUser!.uid)
        .set(data.toJson());
  }


}