import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_udemyintermediate/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isHidden = false.obs;
  TextEditingController emailC =
      TextEditingController(text: "msyafiqaldiansyah@gmail.com");
  TextEditingController passC = TextEditingController(text: "123456");

  void login() async {
    // Menggunakan kode dari dokumentasi FlutterFire, serta jangan lupa mematikan email enumeration di Setting Authentication
    if (emailC.text.isNotEmpty || passC.text.isNotEmpty) {
      try {
        isLoading.value = true;

        final userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          // Fungsi Login dengan email dan password
          email: emailC.text,
          password: passC.text,
        );

        if (userCredential.user!.emailVerified) {
          Get.offAllNamed(Routes.HOME);
          Get.snackbar("Login Success", "Login Success");
        } else {
          Get.snackbar('Something wrong', 'Please verify your email');
          // Menggunakan default dialog untuk resend verification
          Get.defaultDialog(
            radius: 10,
            title: 'Email Verification',
            middleText: 'Please verify your email',
            textConfirm: 'Resend',
            onConfirm: () async {
              await userCredential.user!.sendEmailVerification();
            },
            textCancel: 'Cancel',
            onCancel: () {
              Get.back();
            },
          );
        }

        isLoading.value = false;
      } on FirebaseAuthException catch (e) {
        isLoading.value = false;

        if (e.code == 'user-not-found') {
          // Jika email tidak ada
          Get.snackbar('Something wrong', 'No user found for that email.');
        } else if (e.code == 'wrong-password') {
          // Jika password dari email salah
          Get.snackbar(
              'Something wrong', 'Wrong password provided for that user.');
        }
      }
    } else {
      Get.snackbar('Something wrong', 'Please fill all the fields');
    }
  }
}
