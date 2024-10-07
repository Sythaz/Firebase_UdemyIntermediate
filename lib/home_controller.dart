import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> getStreamNotes() {
    try {
      return firestore // Menggunakan RETURN bukan YIELD
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('notes')
          // Defaultnya data acak, dengan orderBy data lebih tertata
          .orderBy('createdAt')
          .snapshots(); // Mengembalikan STREAM sehingga tidak menggunakan YIELD
    } catch (e) {
      Get.snackbar('Kesalahan', '$e');
      return Stream.error(e);
    }
  }
}
