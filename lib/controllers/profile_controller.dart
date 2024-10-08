import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_udemyintermediate/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isHidden = true.obs;
  RxBool isProfilePic = true.obs;
  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController phoneC = TextEditingController();
  TextEditingController passC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  Future<Map<String, dynamic>?> getDataUser() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> dataDoc =
          await firestore // Data disimpan dalam FIRESTORE (bukan FirebaseStorage)
              .collection('users')
              .doc(auth.currentUser?.uid)
              .get(); // Mengambil data dengan tipe data MAP

      isProfilePic.value = true;
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
        await firestore.collection('users').doc(auth.currentUser!.uid).update({
          'name': nameC.text,
          'phone': phoneC.text,
        });

        if (passC.text.isNotEmpty) {
          // Jika password diisi
          await auth.currentUser!.updatePassword(passC.text); // Update password
          await auth.signOut(); // Lalu logout dan ke LOGIN

          Get.offAllNamed(Routes.LOGIN);
          passC.clear();
        }

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

  // Gambar yang dipilih dan diawasi pada ternary di view menggunakan update()
  XFile? image;
  void pickImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      image = pickedFile;
      update();

      try {
        // Proses upload ke Firebase Storage
        // Jadi, gambar akan terupload saat selesai pemilihan gambar
        if (image != null) {
          String extPic = image!.name
              .split(".")
              .last; // Mengambil kata dibelakang titik (tipe file)
          await storage
              .ref(auth.currentUser!.uid)
              .child('profile.$extPic')
              // File() berguna untuk mengubah path gambar menjadi File
              .putFile(File(image!.path));

          // Mengambil URL profile pic dari Firebase Storage
          String profileUrl = await storage
              .ref(auth.currentUser!.uid)
              .child('profile.$extPic')
              .getDownloadURL();

          // Setelah mendapatkan URL, kirim URL ke Firebase Database
          await firestore
              .collection('users')
              .doc(auth.currentUser!.uid)
              .update({'profile': profileUrl});
        }
      } catch (e) {
        Get.snackbar('Kesalahan', '$e');
      }
    }
  }

  void removeImage() async {
    image = null;
    update();

    try {
      await firestore.collection('users').doc(auth.currentUser!.uid).update({
        // Menghapus 'profile' di firebase database
        'profile': FieldValue.delete(),
      });

      isProfilePic.value = false;
      Get.back();
      update(); // Setelah isProfile menjadi false, butuh update() untuk merefresh GetBuilder
    } catch (e) {
      Get.snackbar('Kesalahan', '$e');
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
