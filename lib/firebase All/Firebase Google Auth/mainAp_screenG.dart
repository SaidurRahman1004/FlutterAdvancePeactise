import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../Custom Widgte/CotactListFnDumpOstad.dart';
import '../../HivePracTiseAll/Contact Book Hive Practise gmn/ContactMainUi.dart';

class homecontactG extends StatelessWidget {
  const homecontactG({super.key});

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth
        .instance
        .currentUser; // বর্তমানে লগইন থাকা ব্যবহারকারীকে খুঁজে বের করা

    //Find User // স্ট্রিম: 'RegUsers' কালেকশন থেকে বর্তমান ব্যবহারকারীর ডকুমেন্ট শোনা হচ্ছে
    final findSnp = FirebaseFirestore.instance
        .collection("RegUsers")
        .doc(currentUser!.uid)
        .snapshots();

    if (currentUser == null) {
      // যদি কোনো কারণে ব্যবহারকারী না পাওয়া যায়, একটি খালি পেজ দেখানো
      return Scaffold(body: Center(child: Text("User Not Found!")));
    }

    //Sign Out Fun

    Future<void> signOut() async {
      await FirebaseAuth.instance.signOut();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Contact Book"),
        actions: [
          IconButton(
            onPressed: () {
              signOut(); // লগআউট ফাংশন
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        // StreamBuilder ব্যবহার করে Firestore থেকে রিয়েল-টাইমে ডেটা পড়া হচ্ছে
        stream: findSnp,
        builder: (_, snapshot) {

          // snapshot.data!.data() একটি অবজেক্ট রিটার্ন করে, তাই Map-এ কাস্ট করতে হয়  // যদি ডেটা সফলভাবে পাওয়া যায়
          final userData = snapshot.data!.data() as Map<String, dynamic>;

          // ডেটা লোড হওয়ার সময় লোডিং ইন্ডিকেটর দেখানো
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // যদি কোনো এরর হয়
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong!"));
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Welcome, ${userData['username']}", style: Theme.of(context).textTheme.headlineMedium,), // ব্যবহারকারীর নাম দেখানো
                SizedBox(height: 20),
                Text(
                  "Email: ${userData['email']}",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 20),
                Text(
                  "Phone: ${userData['phone']}",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 20),
                ElevatedButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => contactListAppDm1(),));
                }, child: Text("Go To NoteApp")),

              ],
            ),
          );
        },
      ),
    );
  }
}
