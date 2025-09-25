import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(FirebaseUi());
}

class FirebaseUi extends StatelessWidget {
  const FirebaseUi({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Demo',
      home: Scaffold(
        appBar: AppBar(title: Text('Firebase Demo')),
        body: Center(
          child: Text('Firebase Connected!'),
        ),

      ),
    );
  }
}
