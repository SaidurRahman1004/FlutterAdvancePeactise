import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../Custom Widgte/InputTextFeild.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

/*
void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: contactListWitheFbFirestore(),
  ));
}

 */

class contactListWitheFbFirestore extends StatefulWidget {
  const contactListWitheFbFirestore({super.key});

  @override
  State<contactListWitheFbFirestore> createState() => _contactListAppState();
}

class _contactListAppState extends State<contactListWitheFbFirestore> {
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  bool _isUploading = false;
  File? imageSrchoice;

  //contact add function r
  void _addContact() async {
    final name = _nameController.text.trim();
    final number = _numberController.text.trim();
    if (name.isNotEmpty && number.isNotEmpty) {
      //Save in FireBase FireStore
      await FirebaseFirestore.instance.collection("ContactList").add({
        'Name': name,
        'Number': number,
        "timestamp": FieldValue.serverTimestamp(),
      });

      _nameController.clear();
      _numberController.clear();
    }
  }

  //delet Contact
  _deleteContact(String docId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Confirmation"),
        content: Text("Are you sure you want to delete this contact?"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.close, color: Colors.grey),
          ),
          IconButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection("ContactList")
                  .doc(docId)
                  .delete();
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),
    );
  }

  //Add Profile image fn
  Future<void> _AddAllnNimageSelection() async {

    //add content
    final name = _nameController.text.trim();
    final number = _numberController.text.trim();

    if (name.isEmpty || number.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Name and Number cannot be empty."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      Map<String, dynamic> noteData = {
        'Name': name,
        'Number': number,
        "timestamp": FieldValue.serverTimestamp(),
      };

      // Image থাকলে upload হবে
      if (imageSrchoice != null) {
        final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        final String filePath =
            "note_images/${FirebaseAuth.instance.currentUser!.uid}/$fileName.jpg";
        final storageRef = FirebaseStorage.instance.ref(filePath);
        if (kIsWeb) {
          final XFile pickedImage = XFile(imageSrchoice!.path);
          final bytes = await pickedImage.readAsBytes();
          await storageRef.putData(bytes, SettableMetadata(contentType: 'image/jpeg'));
        } else {
          await storageRef.putFile(imageSrchoice!);
        }

        await storageRef.putFile(imageSrchoice!);
        final downloadUrl =
        await storageRef.getDownloadURL();

        noteData['imageUrl'] = downloadUrl;




      }

      await FirebaseFirestore.instance.collection("ContactList").add(noteData);

      _nameController.clear();
      _numberController.clear();
      imageSrchoice = null;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Added Successfully"),
            backgroundColor: Colors.green,
          ),
        );
      }
    }  catch (e) {
      if (mounted) {
        // Check if the widget is still mounted
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to upload Contact: $e"),
            backgroundColor: Colors.red,
          ), // Error message
        );
      }
    } finally {
      if (mounted) {
        // Check if the widget is still mounted
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  //pick image fn
  Future<void> _pickImage() async {
    // Pick image from gallery
    final ImagePicker pickimg = ImagePicker();
    final XFile? pickedImage = await pickimg.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage  == null) return;
    if (kIsWeb) {
      setState(() {
        imageSrchoice = File(pickedImage.path); // শুধু প্রিভিউর জন্য
      });
    } else {
      setState(() {
        imageSrchoice = File(pickedImage.path);
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: AppBar(
            title: Text("Contact List"),
            centerTitle: true,
            backgroundColor: Colors.blueGrey,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (_isUploading) const LinearProgressIndicator(),
                SizedBox(height: 10),
                CustomTextField(controller: _nameController, labelText: "Name"),
                SizedBox(height: 10),
                CustomTextField(
                  controller: _numberController,
                  keyboardType: TextInputType.phone,
                  labelText: "Number",
                ),
                SizedBox(height: 10,),
                if(imageSrchoice != null)
                    Container(
                      height: 100,
                      width: 100,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(imageSrchoice!),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                //button for Pick
                OutlinedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text("Select Image"),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _isUploading ? null : _AddAllnNimageSelection,
                  child: Text("Add "),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("ContactList")
                  .orderBy("timestamp", descending: true)
                  .snapshots(),
              builder: (_, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (_, index) {
                    final docData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                    final imageUrl = docData.containsKey('imageUrl') ? docData['imageUrl'] as String? : null;

                    return Card(
                      elevation: 5,
                      child: ListTile(
                        leading: imageUrl != null && imageUrl.isNotEmpty
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            imageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        )
                            : CircleAvatar(
                          child: Text(docData['Name'][0]),
                        ),
                        title: Text(docData["Name"]),
                        subtitle: Text(docData["Number"] ?? ""),
                        trailing: Icon(Icons.call, color: Colors.blue),
                        onLongPress: () => _deleteContact(snapshot.data!.docs[index].id),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
