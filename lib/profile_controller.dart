import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_udemyintermediate/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController phoneC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getDataUser() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> dataDoc =
          await firestore // Data disimpan dalam FIRESTORE (bukan FirebaseStorage)
              .collection('users')
              .doc(auth.currentUser?.uid)
              .get(); // Mengambil data dengan tipe data MAP

      // Karena menggunakan FutureBuilder kita dapat mengirimkan data ke snapshot
      return dataDoc.data();
    } catch (e) {
      Get.snackbar('Something wrong', '$e');
    }
  }

  // Tombol logout berpindah ke profile page
  void logout() async {
    try {
      await auth.signOut();
      Get.offAllNamed(Routes.LOGIN);
      Get.snackbar('Berhasil Logout', 'Anda telah berhasil logout');
    } catch (e) {
      print('CATCH ERORR: $e');
      Get.snackbar('Error sign-out', 'Terjadi error saat melakukan sign-out');
    }
  }
}
