// ignore_for_file: constant_identifier_names

import 'package:firebase_udemyintermediate/views/add_note_view.dart';
import 'package:firebase_udemyintermediate/views/edit_note_view.dart';
import 'package:firebase_udemyintermediate/views/forgot_password_view.dart';
import 'package:firebase_udemyintermediate/views/home_view.dart';
import 'package:firebase_udemyintermediate/views/login_view.dart';
import 'package:firebase_udemyintermediate/profile_view.dart';
import 'package:firebase_udemyintermediate/register_view.dart';
import 'package:firebase_udemyintermediate/splashscreen.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class Routes {
  // Definisi konstanta rute
  static const HOME = '/homePage';
  static const LOGIN = '/loginPage';
  static const SPLASH = '/splashScreen';
  static const REGISTER = '/registerPage';
  static const FORGOTPASSWORD = '/forgotPasswordPage';
  static const PROFILE = '/profilePage';
  static const ADDNOTE = '/addNotePage';
  static const EDITNOTE = '/editNotePage';

  // Gunakan konstanta yang benar dalam GetPage
  static final route = [
    GetPage(name: HOME, page: () => HomeView()), // Gunakan konstanta HOME
    GetPage(name: LOGIN, page: () => LoginView()), // Gunakan konstanta LOGIN
    GetPage(name: SPLASH, page: () => SplashScreen()),
    GetPage(name: REGISTER, page: () => RegisterView()),
    GetPage(name: FORGOTPASSWORD, page: () => ForgotPasswordView()),
    GetPage(name: PROFILE, page: () => ProfileView()),
    GetPage(name: ADDNOTE, page: () => AddNoteView()),
    GetPage(name: EDITNOTE, page: () => EditNoteView())
  ];
}
