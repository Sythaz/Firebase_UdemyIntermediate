import 'package:firebase_udemyintermediate/controllers/login_controller.dart';
import 'package:firebase_udemyintermediate/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginView extends GetView<LoginController> {
  final box = GetStorage(); // Instansiasi

  @override
  Widget build(BuildContext context) {
    if (box.read('rememberme') != null) {
      // Cek tiap kali ke login page
      controller.emailC.text = box.read('rememberme')['email'];
      controller.passC.text = box.read('rememberme')['pass'];
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          'LOGIN',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            keyboardType: TextInputType.emailAddress,
            controller: controller.emailC,
            decoration: InputDecoration(
              labelText: "Email",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          Obx(
            () => TextField(
              keyboardType: TextInputType.visiblePassword,
              obscureText: controller.isHidden.value,
              controller: controller.passC,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () => controller.isHidden.toggle(),
                  icon: Icon(controller.isHidden.isTrue
                      ? Icons.visibility
                      : Icons.visibility_off),
                ),
              ),
            ),
          ),
          Row(
            //Menambahkan tombol remember me
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () => Row(
                  // Membutuhkan row untuk menggabungkan checkbox dan text
                  children: [
                    Checkbox(
                      value: controller.rememberMe.value,
                      // (_) parameter tidak dibutuhkan karena mengatur melalui controller
                      onChanged: (_) => controller.rememberMe.toggle(),
                    ),
                    Text(
                      'Remember me',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => Get.toNamed(Routes.FORGOTPASSWORD),
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Obx(
            () {
              return ElevatedButton(
                onPressed: () {
                  controller.login(); // Memanggil fungsi login
                },
                child: controller.isLoading.isFalse
                    ? Text('Sign In')
                    : Text('Loading...'),
              );
            },
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => Get.toNamed(Routes.REGISTER),
            child: Text('Register'),
          ),
        ],
      ),
    );
  }
}
