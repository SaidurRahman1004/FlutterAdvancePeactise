import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../Custom Widgte/CotactListFnDumpOstad.dart';
import '../../FirebaseFireStore/TestFirestore/contact_store.dart';
import '../../HivePracTiseAll/Contact Book Hive Practise gmn/ContactMainUi.dart';
import 'login_contact_pageG.dart';

class homecontactG extends StatefulWidget {
  const homecontactG({super.key});

  @override
  State<homecontactG> createState() => _homecontactGState();
}

class _homecontactGState extends State<homecontactG> {
  final _usernameEditController = TextEditingController();
  final _phoneEditController = TextEditingController();
  bool _isUpladingImage = false;

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      // ইউজার না থাকলে একটি লোডিং ইন্ডিকেটর দেখান, কারণ AuthGate তাকে লগইন পেজে পাঠিয়ে দেবে
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    final findSnp = FirebaseFirestore.instance
        .collection("RegUsers")
        .doc(currentUser.uid)
        .snapshots();

    // ✅ Sign Out Fun
    Future<void> signOut() async {
      await FirebaseAuth.instance.signOut();
    }

    //Select And Upload Image Fun
    Future<void> _selectAndUploadImage() async {
      final ImagePicker picker = ImagePicker();                                       // Image Picker instance
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);     // Pick an image From gallery
      if(image == null) return;
      setState(() {
        _isUpladingImage = true;  // Uploading start
      });// যদি ইউজার ছবি সিলেক্ট না করে তাহলে ফাংশন থেকে বের হয়ে আসবে

      // Upload to Firebase Storage
      try{
        final String filePatcRef = "profile_pictures/${currentUser!.uid}"; // File path in Firebase Storage
        final File imgFile = File(image.path); // Convert XFile to File

        await FirebaseStorage.instance.ref(filePatcRef).putFile(imgFile); // Upload file to Firebase Storage
        final String downloadUrl = await FirebaseStorage.instance.ref(filePatcRef).getDownloadURL(); // Get download URL
        await FirebaseFirestore.instance.collection("RegUsers").doc(currentUser!.uid).update(  // Update Firestore with new profile picture URL
          {
            "profilePicture" : downloadUrl,
          }
        );
        if(mounted){  // Check if the widget is still mounted
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Profile Picture Updated Successfully"),backgroundColor: Colors.green,), // Success message
          );
        }



      }catch (e){  // Catch any errors
        if(mounted){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to upload image: $e"),backgroundColor: Colors.red,), // Error message
          );
        }
      }finally{
        setState(() {
          if(mounted) setState(() {
            _isUpladingImage = false; // Uploading end
          });
        });
      }

    }

    // ✅ Update Profile Fun
    Future<void> _updateProfile() async {
      if (_usernameEditController.text.isEmpty ||
          _phoneEditController.text.isEmpty) return;

      try {
        await FirebaseFirestore.instance
            .collection('RegUsers')
            .doc(currentUser.uid)
            .update({
          "username": _usernameEditController.text.trim(),
          "phone": _phoneEditController.text.trim(),
        });
        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to update profile.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }

    // ✅ Delete Profile Fun
    Future<void> deleteProfile() async {
      try {
        await FirebaseFirestore.instance
            .collection("RegUsers")
            .doc(currentUser.uid)
            .delete();

        await currentUser.delete();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile deleted successfully!'),
              backgroundColor: Colors.green,
            ),
          );

          // 🔥 Delete এর পর Login Page এ Redirect
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreenCpG()),
                (route) => false,
          );
        }
      } on FirebaseAuthException catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete profile: ${e.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }

    // ✅ Update Profile Dialog
    void _showUpdateDialog(String newName, String newNumber) {
      _usernameEditController.text = newName;
      _phoneEditController.text = newNumber;

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Update Profile"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _usernameEditController,
                  decoration: const InputDecoration(labelText: "New Name"),
                ),
                TextField(
                  controller: _phoneEditController,
                  decoration: const InputDecoration(labelText: "New Phone Number"),
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () => _updateProfile(),
                child: const Text("Update"),
              ),
            ],
          );
        },
      );
    }

    // ✅ Delete Profile Dialog
    void _showDeleteDialog() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Delete Profile?"),
            content: const Text("Are you sure you want to delete your profile?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  deleteProfile();
                },
                child: const Text("Delete"),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => contactListWitheFbFirestore(),
                ),
              );
            },
            child: const Text("Go To NoteApp"),
          ),
          const SizedBox(width: 10),
          IconButton(
            onPressed: () => signOut(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: findSnp,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }



          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("No user data found in Firestore!"));
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading data!"));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>?;

          if (userData == null) {
            return const Center(child: Text("User data is empty!"));
          }
          final profilePictureUrl = userData['profilePicture'] ;

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: profilePictureUrl !=null ? NetworkImage(profilePictureUrl) : null ,   // Display profile picture if available
                        child: profilePictureUrl == null ? const Icon(Icons.person, size: 60) : null, // Default icon if no profile picture
                      ),
                      // Uploading indicator Button
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: FloatingActionButton(
                            onPressed: _selectAndUploadImage,
                          tooltip: "Upload Picture",
                          mini: true,
                          child: _isUpladingImage ? const Padding(padding: EdgeInsets.all(8.0), child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2,)) : const Icon(Icons.camera_alt, size: 20),

                        ),
                      ),
                    ],
                  ),
                  Text("Welcome, ${userData['username'] ?? 'Unknown'}",style: Theme.of(context).textTheme.titleLarge,),
                  Text("Email: ${userData['email'] ?? 'N/A'}"),
                  Text("Phone: ${userData['phone'] ?? 'N/A'}",style: Theme.of(context).textTheme.titleLarge,),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          _showUpdateDialog(userData['username'], userData['phone']);
                        },
                        child: Text("UpdateProfile"),
                      ),
                      SizedBox(width: 20),
                      OutlinedButton(
                        onPressed: () {
                          _showDeleteDialog();
                        },
                        child: Text("DeleteProfile"),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          );
        },
      ),

    );
  }
}
