import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:user_authapp/welcome_page.dart';

import 'login_page.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  late Rx<User?> _user;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(auth.currentUser);
    _user.bindStream(auth.userChanges());
    ever(_user, _intialScreen);
  }

  _intialScreen(User? user) {
    if (user == null) {
      print("Login page");
      Get.offAll(() => LoginPage());
    } else {
      Get.offAll(() => WelcomePage(email: user.email!));
    }
    void register(String email, password) async {
      try {
        await auth.createUserWithEmailAndPassword(
            email: email, password: password);
      } catch (e) {
        Get.snackbar("About User", "User Message",
            backgroundColor: Colors.redAccent,
            snackPosition: SnackPosition.BOTTOM,
            titleText: Text("Account Creation Failed",
                style: TextStyle(color: Colors.white)),
            messageText:
                Text(e.toString(), style: TextStyle(color: Colors.white)));
      }
    }

    void Login(String email, password) async {
      try {
        await auth.signInWithEmailAndPassword(email: email, password: password);
      } catch (e) {
        Get.snackbar("Login User", "Login Message",
            backgroundColor: Colors.redAccent,
            snackPosition: SnackPosition.BOTTOM,
            titleText:
                Text("Login Failed", style: TextStyle(color: Colors.white)),
            messageText:
                Text(e.toString(), style: TextStyle(color: Colors.white)));
      }
    }

    void logOut() async {
      await auth.signOut();
    }
  }

  void register(String trim, String trim2) {}

  void logOut() {}
}
