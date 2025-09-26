import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase All/FireBaseGpt/login_contact_page.dart';
import 'firebase All/FireBaseGpt/mainAp_screen.dart';
import 'ostad_flutter_Assignment/contact_list_app.dart';



void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: contactListApp(),
  ));
}

//////////////////////////////
/*
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: contactFirebaseauth(),
  ));
}

class contactFirebaseauth extends StatelessWidget {
  const contactFirebaseauth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (_,snapshot){
            if(!snapshot.hasData){
              return const LoginScreenCp();
            }
            return homecontact();
          }
      ),
    );
  }
}

 */


////////////////////////////D:\CodesApplication\Flutter\fluttert_test_code\lib\firebase All\FireBaseGpt\login_contact_page.dart///
/*
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: contactFirebaseauth(),
  ));
}

class contactFirebaseauth extends StatelessWidget {
  const contactFirebaseauth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (_,snapshot){
            if(!snapshot.hasData){
              return LoginScreen ();
            }
            return HomeScreen();
          }
      ),
    );
  }
}

 */

///////////////////////D:\CodesApplication\Flutter\fluttert_test_code\lib\firebase All\FireBaseGpt
/*
import 'package:firebase_core/firebase_core.dart';
import '../../firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(debugShowCheckedModeBanner: false,home: AuthGate()));
}

//Auth Gate


class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        // authStateChanges() stream-টি Auth State পরিবর্তন ট্র্যাক করে
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // ব্যবহারকারী লগইন করা অবস্থায় নেই
          if (!snapshot.hasData) {
            return LoginScreen(); // লগইন স্ক্রিন দেখাও
          }
          // ব্যবহারকারী লগইন করা অবস্থায় আছেন
          return HomeScreen(); // হোম স্ক্রিন দেখাও
        },
      ),
    );
  }
}

 */



///////////////////////////D:\CodesApplication\Flutter\fluttert_test_code\lib\HivePracTiseAll\NoteApp
/*
void main() async{
  WidgetsFlutterBinding.ensureInitialized(); // ensure Start Flutter engine
  await Hive.initFlutter(); //
  Hive.registerAdapter(noteModleAdapter()); // Adapter Register
  await Hive.openBox<noteModle>("noteBox"); // Box Open
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: noteScreen()));
}

 */
//////////////////////

///D:\CodesApplication\Flutter\fluttert_test_code\lib\HivePracTiseAll\Contact Book Hive Practise gmn///////
/*
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ensure Start Flutter engine
  await Hive.initFlutter(); //initial Hive
  Hive.registerAdapter(ContactModleAdapter()); // Adapter Register
  await Hive.openBox<ContactModle>("contactBox"); // Box Open
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: ContactScreen()));
}

 */
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
