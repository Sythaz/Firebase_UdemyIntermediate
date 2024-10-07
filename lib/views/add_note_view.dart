import 'package:firebase_udemyintermediate/controllers/add_note_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddNoteView extends GetView<AddNoteController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          'ADD NOTE',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
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
                onPressed: () => controller.addNote(),
                child: controller.isLoading.isFalse
                    ? Text('Add Note')
                    : Text('Loading...'),
              );
            },
          ),
        ],
      ),
    );
  }
}
