import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_udemyintermediate/route/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isHidden = true.obs;
  TextEditingController nameC = TextEditingController();
  TextEditingController phoneC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void register() async {
    if (emailC.text.isNotEmpty ||
        passC.text.isNotEmpty ||
        nameC.text.isNotEmpty ||
        phoneC.text.isNotEmpty) {
      // Validasi password 6 character
      if (passC.text.length >= 6) {
        // Kode dari dokumentasi
        try {
          isLoading.value = true;
          final userCredential =
              //Fungsi register akun baru
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailC.text,
            password: passC.text,
          );

          await userCredential.user?.sendEmailVerification();

          await firestore
              .collection('users') // Pada tabel
              .doc(userCredential.user!.uid) // Dengan id unik (map)
              .set({
            // Tambah atau edit data:
            'name': nameC.text,
            'phone': phoneC.text,
            'email': emailC.text,
            'uid': userCredential.user!.uid,
            'createdAt': DateTime.now().toIso8601String()
          });

          isLoading.value = false;
          Get.offAllNamed(Routes.LOGIN);
          Get.snackbar(
            'Email Verification',
            'Silahkan cek email anda untuk verifikasi akun.',
            duration: Duration(seconds: 5),
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
    } else {
      Get.snackbar('Field Tidak Boleh Kosong', 'Semua field harus diisi');
    }
  }
}
