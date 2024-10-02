import 'package:firebase_udemyintermediate/Register_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterView extends GetView<RegisterController> {
  @override
  Widget build(BuildContext context) {
    Get.put(RegisterController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          'Register',
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
                  controller.register(); // Memanggil fungsi register
                },
                child: controller.isLoading.isFalse
                    ? Text('Sign In')
                    : Text('Loading...'),
              );
            },
          )
        ],
      ),
    );
  }
}
