import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController emailC = TextEditingController();

  void forgotPassword() async {
    if (emailC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: emailC.text); // Fungsinya
        Get.back();
        Get.snackbar('Success', 'Please check your email for reset password');
      } on FirebaseAuthException catch (e) {
        // Ada 2 contoh kesalahan yang bisa terjadi
        if (e.code == 'user-not-found') {
          // Jika email tidak ada
          Get.snackbar('Something wrong', 'No user found for that email.');
        } else if (e.code == 'invalid-email') {
          // Jika email tidak valid
          Get.snackbar('Something wrong', 'Invalid email address');
        } else {
          Get.snackbar('Something wrong', '${e.code}');
        }
      }
      isLoading.value = false;
    } else {
      isLoading.value = false;
      Get.snackbar('Something wrong', 'Please fill the email field');
    }
  }
}
