import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'firestore_service.dart'; // আমাদের সার্ভিস ফাইল

class HomeScreenFb extends StatefulWidget {
  const HomeScreenFb({super.key});

  @override
  State<HomeScreenFb> createState() => _HomeScreenFbState();
}

class _HomeScreenFbState extends State<HomeScreenFb> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  Future<void> _showContactDialog({String? docID, String? currentName, String? currentPhone}) async {
    // যদি আপডেট করা হয়, তাহলে পুরোনো ডেটা দেখানো
    if (currentName != null) _nameController.text = currentName;
    if (currentPhone != null) _phoneController.text = currentPhone;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(docID == null ? 'Add Contact' : 'Update Contact'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Name')),
              TextField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Phone')),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                _nameController.clear();
                _phoneController.clear();
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text(docID == null ? 'Add' : 'Update'),
              onPressed: () {
                if (_nameController.text.isNotEmpty && _phoneController.text.isNotEmpty) {
                  if (docID == null) {
                    _firestoreService.addContact(_nameController.text, _phoneController.text);
                  } else {
                    _firestoreService.updateContact(docID, _nameController.text, _phoneController.text);
                  }
                  _nameController.clear();
                  _phoneController.clear();
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
    // ডায়ালগ বন্ধ হওয়ার পর কন্ট্রোলার ক্লিয়ার করা
    _nameController.clear();
    _phoneController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Contacts'),
        actions: [
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestoreService.getContactsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No contacts found. Add one!'));
          }

          final contacts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];
              String docID = contact.id;
              Map<String, dynamic> data = contact.data() as Map<String, dynamic>;

              return ListTile(
                title: Text(data['name']),
                subtitle: Text(data['phone']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showContactDialog(docID: docID, currentName: data['name'], currentPhone: data['phone']),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _firestoreService.deleteContact(docID),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showContactDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}