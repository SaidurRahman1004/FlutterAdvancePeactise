import 'package:hive/hive.dart';

// এই লাইনটি জেনারেটেড ফাইলকে সংযুক্ত করার জন্য। প্রথমে এটিতে error দেখাবে। flutter packages pub run build_runner build --delete-conflicting-outputs
part 'transaction.g.dart';

@HiveType(typeId: 0) // প্রতিটি মডেলের জন্য typeId ইউনিক হতে হবে।
class Transaction extends HiveObject {
  @HiveField(0) // প্রতিটি ফিল্ডের জন্য index ইউনিক হতে হবে।
  late String title;

  @HiveField(1)
  late double amount;

  @HiveField(2)
  late bool isExpense;

  @HiveField(3)
  late DateTime createdAt;

  Transaction({
    required this.title,
    required this.amount,
    required this.isExpense,
    required this.createdAt,
  });
}