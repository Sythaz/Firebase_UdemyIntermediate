import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_udemyintermediate/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddNoteController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController titleC = TextEditingController();
  TextEditingController descC = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  void addNote() async {
    if (titleC.text.isNotEmpty && descC.text.isNotEmpty) {
      try {
        isLoading.value = true;
        firestore
            .collection('users')
            .doc(auth.currentUser!.uid)
            .collection('notes')
            .add({
          // Dengan add kita menambahkan tabel baru didalam 'notes' berisi data note
          'title': titleC.text,
          'desc': descC.text,
          'createdAt': DateTime.now().toIso8601String(),
        });

        isLoading.value = false;
        Get.offAllNamed(Routes.HOME);
        Get.snackbar('Berhasil', 'Catatan anda telah ditambahkan');

        titleC.clear();
        descC.clear();
      } catch (e) {
        isLoading.value = false;
        Get.snackbar('Kesalahan', '$e');
      }
    } else {
      Get.snackbar('Kesalahan', 'Tolong isi semua field');
    }
  }
}
