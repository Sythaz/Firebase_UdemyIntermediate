import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditNoteController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController titleC = TextEditingController();
  TextEditingController descC = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  //Mirip dengan delete yang meminta data dgn parameter namun menggunaka .update
  void editNote(String docId) async {
    if (titleC.text.isNotEmpty && descC.text.isNotEmpty) {
      try {
        isLoading.value = true;
        await firestore
            .collection('users')
            .doc(auth.currentUser!.uid)
            .collection('notes')
            .doc(docId)
            .update({'title': titleC.text, 'desc': descC.text}); // UPDATE

        Get.back();
        Get.snackbar('Berhasil', 'Catatan anda telah diedit');
        isLoading.value = false;
      } catch (e) {
        isLoading.value = false;
        Get.snackbar('Kesalahan', '$e');
      }
    } else {
      Get.snackbar('Kesalahan', 'Tolong isi semua field');
    }
  }
}
