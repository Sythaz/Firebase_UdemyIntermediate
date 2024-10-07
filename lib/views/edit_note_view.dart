import 'package:firebase_udemyintermediate/controllers/edit_note_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditNoteView extends GetView<EditNoteController> {
  // Mendapatkan argument yang dikirim dari HomeView
  final note = Get.arguments['note'];
  final docId = Get.arguments['docId'];
  

  @override
  Widget build(BuildContext context) {
    if (note != null) {
      controller.titleC.text = note['title'];
      controller.descC.text = note['desc'];
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          'EDIT NOTE',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      // Tidak menggunakan FutureBuilder karena saya pikir bahwa data pasti ada karena editPage diakses saat data tampil di HomeView
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: controller.titleC,
            decoration: InputDecoration(
              labelText: "Title",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: controller.descC,
            decoration: InputDecoration(
              labelText: "Desc",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          Obx(
            () {
              return ElevatedButton(
                onPressed: () => controller.editNote(docId),
                child: controller.isLoading.isFalse
                    ? Text('SAVE')
                    : Text('Loading...'),
              );
            },
          ),
        ],
      ),
    );
  }
}
