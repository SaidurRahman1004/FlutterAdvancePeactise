import 'package:flutter/material.dart';
import 'Hive Ai Test/TransactionScreen.dart';
import 'Hive Ai Test/transaction.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart'; // 1. Hive Flutter ইম্পোর্ট করুন
import 'package:provider/provider.dart';
import 'HivePracTiseAll/Contact Book Hive Practise gmn/ContactMainUi.dart';
import 'HivePracTiseAll/Contact Book Hive Practise gmn/ContactModle.dart';
import 'HiveTask/taskHimeModel.dart';
import 'HiveTask/task_page_ui.dart';
import 'haive Ex Wishlist/product_screen.dart';
import 'haive Ex Wishlist/wishListProduct_model.dart';
import 'haive Ex Wishlist/wishlist_providerLogic.dart';

///D:\CodesApplication\Flutter\fluttert_test_code\lib\HivePracTiseAll\Contact Book Hive Practise gmn///////
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ensure Start Flutter engine
  await Hive.initFlutter(); //initial Hive
  Hive.registerAdapter(ContactModleAdapter()); // Adapter Register
  await Hive.openBox<ContactModle>("contactBox"); // Box Open
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: ContactScreen()));
}
///////////////D:\CodesApplication\Flutter\fluttert_test_code\lib\Hive Ai Test\TransactionScreen.dart////////
/*
void main() async {
  // ফ্লাটার অ্যাপ শুরু হওয়ার আগে Hive ইনিশিয়ালাইজ করা নিশ্চিত করতে হবে
  await Hive.initFlutter();

  // আমাদের কাস্টম অবজেক্টের জন্য Adapter রেজিস্টার করতে হবে
  Hive.registerAdapter(TransactionAdapter());

  // 'transactions' নামে একটি বক্স খুলতে হবে
  await Hive.openBox<Transaction>('transactions');

  runApp(const HiveAiAdvtrans());
}

 */

//////////////////D:\CodesApplication\Flutter\fluttert_test_code\lib\HiveTask////////////////
/*
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized(); // ensure Start Flutter engine
  Hive.initFlutter(); //
  Hive.registerAdapter(taskModelHAdapter()); // Adapter Register
  await Hive.openBox<taskModelH>("tasksBox");

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
      home: taskPageUi()));
}

 */

////wishProduct
/*
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();  //// ensure Start Flutter engine
  await Hive.initFlutter();  //Start Hive
  Hive.registerAdapter(wishProductAdapter()); // wishProductAdapter Adapter Register from wishListProduct_model.dart
  await Hive.openBox<wishProduct>("wishListControlElement"); // wishListControlElement Box Open


  runApp(
    ChangeNotifierProvider(
      create: (context) => WishlistProvider(),
      child:  wishListUi(),
    ),
  );
}

 */

/////Hive Main
/*
void main() async { // 3. main() ফাংশনকে async করুন

  // 4. ফ্লাটার অ্যাপ শুরু করার আগে সব প্লাগইন যেন ঠিকমতো চালু হয় তা নিশ্চিত করুন
  WidgetsFlutterBinding.ensureInitialized();

  // 5. Hive চালু করুন
  await Hive.initFlutter();

  // 6. আপনার কাস্টম অবজেক্ট (Task) এর জন্য Adapter রেজিস্টার করুন
  Hive.registerAdapter(TaskAdapter());

  // 7. 'tasks' নামের বক্সটি খুলুন। এটি একটি Future, তাই await ব্যবহার করুন
  await Hive.openBox<Task>('tasks');

  // 8. এখন আপনার অ্যাপ রান করুন
  runApp(MaterialApp(
    home: TaskScreen(),
  ));
}


 */
// আপনার বাকি কোড (যেমন MyApp ক্লাস) অপরিবর্তিত থাকতে পারে
//Temp
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
