import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttert_test_code/HivePracTiseAll/NoteApp/note_app_model.dart';
import 'package:fluttert_test_code/HivePracTiseAll/NoteApp/note_ui.dart';
import 'package:fluttert_test_code/StateManageMentExtra/Provider_with_api_projects.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'Custom Widgte/CotactListFnDumpOstad.dart';
import 'FirebaseFireStore/TestFirestore/contact_store.dart';
import 'firebase All/FireBaseGpt/login_contact_page.dart';
import 'firebase All/FireBaseGpt/mainAp_screen.dart';
import 'firebase All/Firebase Google Auth/login_contact_pageG.dart';
import 'firebase All/Firebase Google Auth/mainAp_screenG.dart';
import 'firebase All/TestfB/HomeScreen.dart';
import 'firebase All/TestfB/widgets/auth_wrapper.dart';
import 'ostad_flutter_Assignment/contact_list_app.dart';

/////test FireBase
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

//////////////////////////////////D:\CodesApplication\Flutter\fluttert_test_code\lib\firebase All\FullCurdAiReGen///
import 'firebase_options.dart'; // flutterfire configure দিয়ে তৈরি হওয়া ফাইল

//new Function For FCM
// **** নতুন ফাংশন: FCM শুরু এবং কনফিগার করার জন্য ****
///FCM Token ঃ dz0yalMbRG6gLTP7k2M3jL:APA91bFO4_-FacEIs1evG1kRthe1VOU5X1-5czVKdXg7V1y0R_srE2g-7dMJSn20JM0sD0Y8RW5YBXy9blEElPXFP93FmZwUfPVFB1V0kkQvtdP88KG_Dew
Future<void> _initializeFCM() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // ১. ব্যবহারকারীর কাছ থেকে নোটিফিকেশনের জন্য অনুমতি চাওয়া
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('✅ User granted permission for notifications');
  } else {
    print('❗️ User declined or has not accepted permission');
  }

  // ২. ডিভাইসের জন্য ইউনিক FCM টোকেন সংগ্রহ করা
  final String? fcmToken = await messaging.getToken();
  print('📱 FCM Token: $fcmToken');
  // TODO: এই টোকেনটি Firestore-এ ব্যবহারকারীর ডকুমেন্টের সাথে সেভ করতে হবে
  // যাতে আপনি নির্দিষ্ট ব্যবহারকারীকে নোটিফিকেশন পাঠাতে পারেন।

  // ৩. অ্যাপ যখন খোলা (Foreground) অবস্থায় থাকে, তখন নোটিফিকেশন হ্যান্ডেল করা
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('🔔 Got a message whilst in the foreground!');
    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification!.title}');
      // এখানে আপনি একটি কাস্টম ডায়ালগ বা লোকাল নোটিফিকেশন দেখাতে পারেন
    }
  });
}
/*
void main() async {
  // Flutter বাইন্ডিং শুরু হয়েছে কিনা তা নিশ্চিত করা
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase শুরু করা
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyAppReFbCurd());
}

class MyAppReFbCurd extends StatelessWidget {
  const MyAppReFbCurd({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        brightness: Brightness.dark, // ডার্ক থিম
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      // অ্যাপের হোম হিসেবে AuthGate সেট করা হলো
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // যদি স্ট্রিম থেকে এখনো কোনো ডেটা না আসে
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // যদি snapshot-এ ডেটা থাকে, তার মানে ব্যবহারকারী লগইন করা আছে
        if (snapshot.hasData) {
          return const HomeScreen(); // হোম স্ক্রিনে পাঠানো হলো
        }

        // যদি snapshot-এ ডেটা না থাকে, তার মানে ব্যবহারকারী লগইন করা নেই
        return const LoginScreen(); // লগইন স্ক্রিনে পাঠানো হলো
      },
    );
  }
}

 */
//.................................................
//////////////////////////////D:\CodesApplication\Flutter\fluttert_test_code\lib\FirebaseFireStore\TestFirestore///
//FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await _initializeFCM();
  if(kDebugMode){
    try{
      FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);

      // Storage Emulator connect
      await FirebaseStorage.instance.useStorageEmulator('localhost', 9199);
      print("✅ Firebase Storage Emulator successfully connected!");
    }catch (e){
      print("❗️ Error connecting to Firebase Storage Emulator: $e");
    }
  }


  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: contactListWitheFbFirestore(),
  ));
}




/*
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await _initializeFCM();

  runApp(const MyAppFireBaseApiAiTest());
}

class MyAppFireBaseApiAiTest extends StatelessWidget {
  const MyAppFireBaseApiAiTest({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Auth Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const AuthWrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}

 */



////D:\CodesApplication\Flutter\fluttert_test_code\lib\StateManageMentExtra\Provider_with_api_projects.dart/////////////////////
/*
void main() {
  runApp(
      ChangeNotifierProvider(
        create: (_)=>ProductProvider(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: ProviderProjApiIn(),
        ),
      )
  );
}

 */



//......................D:\CodesApplication\Flutter\fluttert_test_code\lib\firebase All\Firebase Google Auth............................................
//Firebase Emolator  firebase emulators:start --only storage
/*

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
  );
  if (kDebugMode) {
    try{
      await FirebaseStorage.instance.useStorageEmulator('localhost', 9199);
      print("✅ Firebase Storage Emulator successfully connected!");
    }catch(e){
      print("❗️ Error connecting to Firebase Storage Emulator: $e");
    }

  }
  runApp(const contactFirebaseauth());
}

class contactFirebaseauth extends StatelessWidget {
  const contactFirebaseauth({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          return const homecontactG();
        }
        return const LoginScreenCpG();
      },
    );
  }
}

 */


/*
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const contactFirebaseauth());
}

class contactFirebaseauth extends StatelessWidget {
  const contactFirebaseauth({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          return const homecontactG();
        }
        return const LoginScreenCpG();
      },
    );
  }
}



 */

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

////////////////////////////D:\CodesApplication\Flutter\fluttert_test_code\lib\firebase All\FireBaseGpt\login_contact_pageG.dart///
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
void main() async {
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
