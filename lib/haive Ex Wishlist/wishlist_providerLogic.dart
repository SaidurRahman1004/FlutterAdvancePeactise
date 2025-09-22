import 'package:flutter/material.dart'; // Flutter এর Material Design উইজেট এবং থিম ব্যবহার করার জন্য এই প্যাকেজটি ইম্পোর্ট করা হয়েছে।
import 'dart:collection'; // ডেটা স্ট্রাকচার যেমন List, Map ইত্যাদি ব্যবহারের জন্য এই প্যাকেজটি ইম্পোর্ট করা হয়েছে।

import 'package:fluttert_test_code/haive%20Ex%20Wishlist/wishListProduct_model.dart'; // wishProduct মডেল ক্লাসটি ইম্পোর্ট করা হয়েছে, যা প্রতিটি উইশলিস্ট আইটেমের ডেটা ধারণ করে।
import 'package:hive/hive.dart'; // Hive ডাটাবেস ব্যবহারের জন্য এই প্যাকেজটি ইম্পোর্ট করা হয়েছে, যা লোকাল স্টোরেজে ডেটা সংরক্ষণ করতে ব্যবহৃত হয়।

class WishlistProvider extends ChangeNotifier {
  // WishlistProvider ক্লাস ChangeNotifier এক্সটেন্ড করে তৈরি করা হয়েছে, যাতে UI তে পরিবর্তনগুলো জানানো যায়।
  final Box<wishProduct> _wishlistItems = Hive.box<wishProduct>(
      "wishListControlElement"); // "wishListControlElement" নামে একটি Hive বক্স খোলা হয়েছে, যেখানে wishProduct অবজেক্টগুলো সংরক্ষণ করা হবে। _wishlistItems একটি প্রাইভেট ভেরিয়েবল যা এই বক্সটিকে রেফার করে।
  Box<wishProduct> get wishlistItems =>
      _wishlistItems; // wishlistItems একটি গেটার (getter) যা _wishlistItems বক্সটিকে অ্যাক্সেস করার অনুমতি দেয়। এর মাধ্যমে উইশলিস্টের আইটেমগুলো পড়া যাবে।


  void addItem(String itemName) {
    // উইশলিস্টে নতুন আইটেম যোগ করার জন্য এই মেথডটি তৈরি করা হয়েছে। এটি একটি স্ট্রিং প্যারামিটার (itemName) নেয়।
    final isExisting = _wishlistItems.values.any((item) =>
    item.name ==
        itemName); // প্রথমে চেক করা হয় যে একই নামের কোন আইটেম ইতিমধ্যে উইশলিস্টে আছে কিনা। any মেথডটি তালিকার যেকোনো একটি আইটেমের জন্য শর্ত পূরণ হলেই true রিটার্ন করে।
    if (!isExisting) { // যদি আইটেমটি ইতিমধ্যে না থাকে, তাহলেই কেবল নতুন আইটেম যোগ করা হবে।
      final newProduct = wishProduct(
          name: itemName); // itemName ব্যবহার করে একটি নতুন wishProduct অবজেক্ট তৈরি করা হয়।
      _wishlistItems.add(
          newProduct); // তৈরি করা নতুন wishProduct অবজেক্টটি Hive বক্স (_wishlistItems) এ যোগ করা হয়। এর ফলে ডেটা লোকাল স্টোরেজে সেভ হয়ে যাবে।
      notifyListeners(); // এই মেথডটি কল করার মাধ্যমে ChangeNotifier তার লিসেনারদের (সাধারণত UI উইজেট) জানায় যে ডেটাতে পরিবর্তন এসেছে, ফলে UI আপডেট হতে পারে।
    }
  }

  void removeItem(int index) {
    // উইশলিস্ট থেকে একটি নির্দিষ্ট ইনডেক্সের আইটেম মুছে ফেলার জন্য এই মেথডটি তৈরি করা হয়েছে। এটি একটি ইন্টিজার প্যারামিটার (index) নেয়।
    _wishlistItems.deleteAt(
        index); // _wishlistItems বক্স থেকে নির্দিষ্ট ইনডেক্সের আইটেমটি মুছে ফেলা হয়। এটি লোকাল স্টোরেজ থেকেও ডেটা মুছে ফেলবে।
    notifyListeners(); // এই মেথডটি কল করার মাধ্যমে ChangeNotifier তার লিসেনারদের জানায় যে ডেটাতে পরিবর্তন এসেছে, ফলে UI আপডেট হতে পারে।
  }
}