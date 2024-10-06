import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_udemyintermediate/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  RxBool isLoading = false.obs;
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
      // Karena fungsi return yang bukan VOID maka wajib terdapat return di semua kondisi
      return null;
    }
  }

  Future<void> editDataUser() async {
    if (nameC.text.isNotEmpty && phoneC.text.isNotEmpty) {
      try {
        isLoading.value = true;
        // EDIT Tidak menggunakan SET!
        // UPDATE mengganti data lama yang sudah ada
        // Sedangkan SET, data lama akan hilang dan diganti yang baru
        await firestore.collection('users').doc(auth.currentUser?.uid).update({
          'name': nameC.text,
          'phone': phoneC.text,
        });
        isLoading.value = false;
        Get.snackbar('Berhasil', 'Anda telah berhasil mengedit profil');
      } catch (e) {
        isLoading.value = false;
        Get.snackbar('Kesalahan', '$e');
      }
    } else {
      Get.snackbar('Kesalahan', 'Semua field harus diisi');
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
