import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'note_app_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ensure Start Flutter engine
  await Hive.initFlutter(); //
  Hive.registerAdapter(noteModleAdapter()); // Adapter Register
  await Hive.openBox<noteModle>("noteBox"); // Box Open
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: noteScreen()));
}

class noteScreen extends StatefulWidget {
  const noteScreen({super.key});

  @override
  State<noteScreen> createState() => _noteScreenState();
}

class _noteScreenState extends State<noteScreen> {
  final Box<noteModle> noteBoxStore = Hive.box<noteModle>("noteBox");
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  //Add Note Function
  void _addNote() {
    final addTitle = titleController.text;
    final addContent = contentController.text;
    if (addTitle.isNotEmpty && addContent.isNotEmpty) {
      final newNote = noteModle(title: addTitle, content: addContent);
      noteBoxStore.add(newNote); // Box এ নতুন ডেটা যোগ করা হলো
      titleController.clear();
      contentController.clear();
      Navigator.of(context).pop();
    }
  }

  //Edit Note
  _editNote(int index) {
    if (titleController.text.isNotEmpty && contentController.text.isNotEmpty) {
      noteBoxStore.putAt(
        index,
        noteModle(title: titleController.text, content: contentController.text),
      );
      titleController.clear();
      contentController.clear();
      Navigator.of(context).pop();
    }
  }

  //Delete Note Function
  _deleteNote(int index) {
    noteBoxStore.deleteAt(index);
  }

  //Çustom DialogBox Re Useable
  Future<void> dialogOptionsCustom({
    required BuildContext context,
    required String title, // Title যেমন: "Add" বা "Edit"
    required TextEditingController nameController, // ডাইনামিক Controller
    required TextEditingController contentController,
    required VoidCallback onSave, // Save বাটনের action
    VoidCallback? onCancel,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Note Title",
                  hintText: "Enter Your Note name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: contentController,
                decoration: InputDecoration(
                  labelText: "Note",
                  hintText: "Write Your Note HAre",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: onCancel ?? () => Navigator.of(context).pop(),
              child: Text("Cencle"),
            ),
            TextButton(
              onPressed: () {
                onSave();
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("BestNote")),
      body: ValueListenableBuilder(
        valueListenable: noteBoxStore.listenable(),
        builder: (_, Box<noteModle> box, _) {
          if (noteBoxStore.isEmpty) {
            return Center(
              child: Text(
                "No Note Found",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (_, index) {
              final contentBoxControlElement = box.getAt(index)!;
              return ListTile(
                title: Text(contentBoxControlElement.title),
                subtitle: Text(contentBoxControlElement.content),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        _deleteNote(index);
                      },
                      icon: Icon(Icons.delete, color: Colors.redAccent),
                    ),
                    IconButton(
                      onPressed: () {
                        dialogOptionsCustom(
                          context: context,
                          title: "Edit Yourr Note",
                          nameController: titleController,
                          contentController: contentController,
                          onSave: (){_editNote(index);},
                        );
                      },
                      icon: Icon(Icons.edit, color: Colors.blue),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          dialogOptionsCustom(
            context: context,
            title: "Type Your Note",
            nameController: titleController,
            contentController: contentController,
            onSave: _addNote,
          );
        },
        child: Icon(Icons.add_circle_outline, color: Colors.redAccent),
      ),
    );
  }
}
