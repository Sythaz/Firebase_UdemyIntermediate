import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_udemyintermediate/controllers/add_note_controller.dart';
import 'package:firebase_udemyintermediate/controllers/edit_note_controller.dart';
import 'package:firebase_udemyintermediate/controllers/home_controller.dart';
import 'package:firebase_udemyintermediate/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    Get.put(AddNoteController());
    Get.put(EditNoteController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'HOME',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        actions: [
          // Menggunakan stream untuk mengambil data gambar/informasi pribadi user nanti
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>?>(
              stream: controller.streamProfile(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircleAvatar(
                    maxRadius: 18,
                    backgroundColor: Colors.grey[300],
                  );
                }
                // CircleAvatar tdk bisa onTap sehingga butuh widget ini
                return GestureDetector(
                  onTap: () => Get.toNamed(Routes.PROFILE),
                  child: CircleAvatar(
                    maxRadius: 18,
                    backgroundImage: NetworkImage(
                      "https://ui-avatars.com/api/?name=${snapshot.data!.data()?['name']}.jpg", // tambah .jpg
                    ),
                  ),
                );
              }),
          SizedBox(width: 10),
        ],
      ),
      body: StreamBuilder(
        stream: controller.getStreamNotes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data?.docs.length == 0) {
            return Center(child: Text('No data!'));
          }
          return ListView.builder(
            // Menggunakan .docs karena .data berbentuk query bukan sebuah list yang bisa dihitung
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) {
              final note = snapshot.data?.docs[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text("${index + 1}"),
                ),
                title: Text(note!['title']),
                subtitle: Text(note['desc']),
                trailing: IconButton(
                  // Mengirimkan id dari ListTile untuk dihapus
                  onPressed: () => controller.deleteNote(note.id),
                  icon: Icon(Icons.delete),
                ),
                onTap: () => Get.toNamed(Routes.EDITNOTE,
                    arguments: {'note': note, 'docId': note.id}),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.ADDNOTE),
        child: Icon(Icons.add),
      ),
    );
  }
}
