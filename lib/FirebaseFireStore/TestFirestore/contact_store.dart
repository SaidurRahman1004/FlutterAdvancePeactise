import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../../Custom Widgte/InputTextFeild.dart';

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
                CustomTextField(controller: _nameController, labelText: "Name"),
                SizedBox(height: 10),
                CustomTextField(
                  controller: _numberController,
                  keyboardType: TextInputType.phone,
                  labelText: "Number",
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    _addContact();
                  },
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
                    final dataControl = snapshot.data!.docs[index];
                    return Card(
                      elevation: 5,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blueGrey,
                          foregroundColor: Colors.white,
                          child: Text(dataControl['Name'][0],style: const TextStyle(fontWeight: FontWeight.bold),),
                        ),
                        title: Text(dataControl["Name"]),
                        subtitle: Text(dataControl["Number"]??""),
                        trailing: Icon(Icons.call, color: Colors.blue),
                        onLongPress: () =>
                        _deleteContact( dataControl.id ),
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
