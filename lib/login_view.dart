import 'package:firebase_udemyintermediate/login_controller.dart';
import 'package:firebase_udemyintermediate/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
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
            controller: controller.emailC,
            decoration: InputDecoration(
              labelText: "Email",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: controller.passC,
            decoration: InputDecoration(
              labelText: "Password",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
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
            onPressed: () => Get.offAllNamed(Routes.REGISTER),
            child: Text('Register'),
          ),
        ],
      ),
    );
  }
}
