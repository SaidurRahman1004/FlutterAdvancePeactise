//Create Model And TypeAdapter
//flutter pub run build_runner build
import 'package:hive/hive.dart';

part 'task_model.g.dart'; // জেনারেট হওয়া ফাইলের নাম

@HiveType(typeId: 0) // প্রতিটি Hive অবজেক্টের জন্য একটি অনন্য typeId দিতে হয়
class Task {
  @HiveField(0) // প্রতিটি ফিল্ডের জন্য একটি অনন্য নম্বর
  String title;

  @HiveField(1)
  bool isCompleted;

  Task({required this.title, this.isCompleted = false});
}