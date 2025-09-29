import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  // কালেকশনের একটি রেফারেন্স তৈরি করা
  final CollectionReference contacts =
  FirebaseFirestore.instance.collection('contacts');

  // 현재 ব্যবহারকারীর UID পাওয়া
  final String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;

  // CREATE: নতুন কন্টাক্ট যোগ করা
  Future<void> addContact(String name, String phone) {
    return contacts.add({
      'name': name,
      'phone': phone,
      'timestamp': Timestamp.now(),
      'userId': currentUserUid, // লগইন করা ইউজারের আইডি যোগ করা
    });
  }

  // READ: কন্টাক্টগুলোর রিয়েল-টাইম Stream পাওয়া
  Stream<QuerySnapshot> getContactsStream() {
    // শুধুমাত্র বর্তমান ইউজারের কন্টাক্টগুলো পাওয়ার জন্য কোয়েরি
    return contacts
        .where('userId', isEqualTo: currentUserUid)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // UPDATE: কন্টাক্ট আপডেট করা
  Future<void> updateContact(String docID, String newName, String newPhone) {
    return contacts.doc(docID).update({
      'name': newName,
      'phone': newPhone,
    });
  }

  // DELETE: কন্টাক্ট ডিলিট করা
  Future<void> deleteContact(String docID) {
    return contacts.doc(docID).delete();
  }
}