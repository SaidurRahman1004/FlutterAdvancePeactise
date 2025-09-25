import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../HivePracTiseAll/Contact Book Hive Practise gmn/ContactMainUi.dart';

class homecontact extends StatelessWidget {
   homecontact({super.key});
  final User? usercn = FirebaseAuth.instance.currentUser;
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ContactPage"),
        actions: [
          IconButton(
            tooltip: 'Logout',
            icon: Icon(Icons.logout),
            onPressed: signOut,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Successfully Logged In!',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              "Email: ${usercn?.email ?? "No email found"}",
              style: const TextStyle(fontSize: 16),
            ),

            Text(
              "UID: ${usercn?.uid ?? "No UID found"}",
              style: const TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ContactScreen()));
            }, child: Text("Go To Contact"),
            ),
          ],
        ),
      ),
    );
  }
}
