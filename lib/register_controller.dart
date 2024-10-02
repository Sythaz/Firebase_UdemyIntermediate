import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_udemyintermediate/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isHidden = false.obs;
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();

  void register() async {
    if (emailC.text.isNotEmpty || passC.text.isNotEmpty) {
      if (passC.text.length >= 6) { // Validasi password 6 character
      // Kode dari dokumentasi
        try {
          isLoading.value = true;
          final userCredential =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
                //Fungsi register akun baru
            email: emailC.text,
            password: passC.text,
          );

          isLoading.value = false;
          Get.offAllNamed(Routes.LOGIN);
          Get.snackbar(
            'Berhasil Register',
            'Anda berhasil register, silahkan login',
          );
        } on FirebaseAuthException catch (e) {
          isLoading.value = false;
          if (e.code == 'weak-password') {
            print('The password provided is too weak.');
          } else if (e.code == 'email-already-in-use') {
            print('The account already exists for that email.');
          }
        } catch (e) {
          print(e);
        }
      } else {
        Get.snackbar(
          'Password Tidak Valid',
          'Password harus lebih dari 6 karakter',
        );
      }
    }
  }
}
