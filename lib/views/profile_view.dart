import 'dart:io';

import 'package:firebase_udemyintermediate/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileView extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    Get.put(ProfileController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          'PROFILE',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => controller.logout(),
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: FutureBuilder(
          // Menggunakan FutureBuilder agar tiap masuk ke profile page, data terpanggil
          future: controller.getDataUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.data == null) {
              return Center(child: Text('No data!'));
            } else {
              // Inisialisasi data TextField
              controller.nameC.text = snapshot.data?['name'];
              controller.emailC.text = snapshot.data?['email'];
              controller.phoneC.text = snapshot.data?['phone'];
              return ListView(
                padding: EdgeInsets.all(20),
                children: [
                  Column(
                    children: [
                      GetBuilder<ProfileController>(
                        builder: (contr) {
                          return snapshot.data?['profile'] != null
                              ? Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Colors.grey[400],
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            snapshot.data!['profile']),
                                      )),
                                )
                              : contr.image != null
                                  ? Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: Colors.grey[400],
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: FileImage(
                                              File(contr.image!.path),
                                            ),
                                          )),
                                    )
                                  : CircleAvatar(
                                      maxRadius: 50,
                                      child: Text('No image'),
                                    );
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                              onPressed: () => controller.pickImage(),
                              child: Text('Choose image')),
                          SizedBox(width: 20),
                          TextButton(
                            onPressed: () => controller.resetImage(),
                            child: Text('Remove image'),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  TextField(
                    keyboardType: TextInputType.name,
                    controller: controller.nameC,
                    decoration: InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    readOnly: true,
                    keyboardType: TextInputType.emailAddress,
                    controller: controller.emailC,
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    keyboardType: TextInputType.phone,
                    controller: controller.phoneC,
                    decoration: InputDecoration(
                      labelText: "Phone number",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  Obx(
                    () => TextField(
                      obscureText: controller.isHidden.value,
                      keyboardType: TextInputType.visiblePassword,
                      controller: controller.passC,
                      decoration: InputDecoration(
                        labelText: "New Password",
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
                  SizedBox(height: 20),
                  Obx(
                    () => ElevatedButton(
                      onPressed: () => controller.editDataUser(),
                      child: Text(controller.isLoading.isFalse
                          ? 'SAVE EDIT'
                          : 'Loading...'),
                    ),
                  ),
                ],
              );
            }
          }),
    );
  }
}
