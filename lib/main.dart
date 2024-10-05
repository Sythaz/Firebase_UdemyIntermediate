import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_udemyintermediate/home_controller.dart';
import 'package:firebase_udemyintermediate/login_controller.dart';
import 'package:firebase_udemyintermediate/route/routes.dart';
import 'package:firebase_udemyintermediate/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseAuth auth = FirebaseAuth.instance; // Memanggil instance FirebaseAuth

  await GetStorage.init(); // Inisialisasi storage local database

  Get.put(LoginController());
  Get.put(HomeController());
  runApp(
    StreamBuilder<User?>(
      stream: auth
          .authStateChanges(), // Perubahan dapat didapatkan dari fungsi authStateChanges()
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SplashScreen();
        }
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Firebase Udemy Intermediate',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
            useMaterial3: true,
          ),
          initialRoute: snapshot.data != null && snapshot.data!.emailVerified
              ? Routes.HOME
              : Routes.LOGIN,
          getPages: Routes.route,
        );
      },
    ),
  );
}
