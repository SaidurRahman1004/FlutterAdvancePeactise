import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreenC extends StatelessWidget {
  const HomeScreenC({super.key});

  @override
  Widget build(BuildContext context) {
    // বর্তমানে লগইন থাকা ব্যবহারকারীর তথ্য পাওয়া
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          // লগআউট করার জন্য IconButton
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              // সাইন আউট সফল হলে AuthGate স্বয়ংক্রিয়ভাবে লগইন পেজে নিয়ে যাবে
            },
          )
        ],
      ),
      body: Center(
        // ব্যবহারকারীর ইমেইল দেখানো হচ্ছে
        child: Text(
          'Welcome!\nYou are logged in as:\n${user?.email}',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}