import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttert_test_code/firebase%20All/FireBaseGpt/singUp_contact_page.dart';
import 'package:hive/hive.dart';
import '../../HivePracTiseAll/NoteApp/note_app_model.dart';
import '../../HivePracTiseAll/NoteApp/note_ui.dart';
import '../../Custom Widgte/InputTextFeild.dart';
import 'mainAp_screen.dart';
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
            return HomeScreenC();
          }
      ),
    );
  }
}

//login Screen
class LoginScreenCp extends StatefulWidget {
  const LoginScreenCp({super.key});

  @override
  State<LoginScreenCp> createState() => _LoginScreenCpState();
}

class _LoginScreenCpState extends State<LoginScreenCp> {
  final _textEmail = TextEditingController();
  final _textPassword = TextEditingController();
  bool _isLoading = false;

  //Sing In Function
  Future<void> SingIn() async{
    setState(() {
      _isLoading = true;
    });

    try{
      // Firebase-এ সাইন ইন করার চেষ্টা
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: _textEmail.text.trim(), password: _textPassword.text.trim());
      if(mounted) Navigator.of(context).pop();
    }on FirebaseAuthException catch(e){

      String message = 'Failed to sign in. Please check your credentials.';
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        message = 'Invalid email or password.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ));
    }finally{
      if(mounted){
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  //avoid memory Leak
  @override
  void dispose(){
    _textEmail.dispose();
    _textPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Note Task'), centerTitle: true),
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
                      Text("Sing in",style: TextStyle( color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 30 ),),
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
                      OutlinedButton(onPressed: (){SingIn();}, child: Text("Sing in")),
                      SizedBox(height: 30,),
                      _isLoading ? const Center(child: CircularProgressIndicator()) : TextButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpContactScreen(),));
                      }, child: Text("Don\'t have an account? Sign Up")),

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
