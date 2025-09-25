import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../HivePracTiseAll/NoteApp/note_ui.dart';
import '../../Custom Widgte/InputTextFeild.dart';
import 'login_contact_page.dart';

class SignUpContactScreen extends StatefulWidget {
  const SignUpContactScreen({super.key});

  @override
  State<SignUpContactScreen> createState() => _SignUpContactScreenState();
}

class _SignUpContactScreenState extends State<SignUpContactScreen> {
  final _textEmail = TextEditingController();
  final _textPassword = TextEditingController();
  bool _isLoading = false;

  //Sing Up Function
  Future<void> SingUp() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _textEmail.text.trim(),
        password: _textPassword.text.trim(),
      );

      // রেজিস্ট্রেশন সফল হলে ব্যবহারকারী স্বয়ংক্রিয়ভাবে লগইন হয়ে যাবে
      // তাই আগের স্ক্রিনে ফিরে যাই (AuthGate তাকে হোমপেজে পাঠাবে)
      if (mounted) Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      // যদি কোনো ত্রুটি হয়, ব্যবহারকারীকে একটি বার্তা দেখাই
      String message;
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      } else {
        message = 'An error occurred. Please try again.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'An error occured'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      //Loadind End
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  //avoid memory Leak
  @override
  void dispose() {
    _textEmail.dispose();
    _textPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 10,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  height: 400,
                  width: 350,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Sing Up",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 300,
                        child: CustomTextField(
                          controller: _textEmail,
                          hintText: "Enter Valid Email",
                          labelText: "Email",
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 300,
                        child: CustomTextField(
                          controller: _textPassword,
                          hintText: "Enter Valid Password",
                          labelText: "Password",
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                        ),
                      ),
                      const SizedBox(height: 20),
                      OutlinedButton(
                        onPressed: () {
                          SingUp();
                        },
                        child: Text("Sing Up"),
                      ),
                      SizedBox(height: 30),
                      // লোডিং হলে বাটন ডিজেবল থাকবে এবং ইন্ডিকেটর দেখাবে
                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreenCp(),
                                  ),
                                );
                              },
                              child: Text(
                                "Already have an account? Go to Sign in",
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
