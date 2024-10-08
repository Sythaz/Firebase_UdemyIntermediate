import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> getStreamNotes() {
    // Aman tidak menggunakan await karena firestore sudah mengatasinya dibalik layar (?)
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

  void deleteNote(String docId) async {
    try {
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('notes')
          // List yang ditekan mengirimkan data id docnya dari HomeView
          .doc(docId)
          .delete();
    } catch (e) {
      Get.snackbar('Kesalahan', '$e');
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>>? streamProfile() {
    try {
      return firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .snapshots();
    } catch (e) {
      Get.snackbar('Kesalahan', '$e');
    }
  }
}
