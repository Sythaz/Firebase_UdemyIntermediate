import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_udemyintermediate/route/routes.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  void logout() async {
    try {
      await auth.signOut();
      Get.offAllNamed(Routes.LOGIN);
      Get.snackbar('Berhasil Logout', 'Anda telah berhasil logout');
    } catch (e) {
      print('CATCH ERORR: ${e}');
      Get.snackbar('Error sign-out', 'Terjadi error saat melakukan sign-out');
    }
  }
}
