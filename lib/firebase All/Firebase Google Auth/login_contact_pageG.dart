import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttert_test_code/firebase%20All/Firebase%20Google%20Auth/singUp_contact_pageG.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../Custom Widgte/InputTextFeild.dart'; // গুগল সাইন-ইন প্যাকেজ ইম্পোর্ট


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
              return const LoginScreenCpG();
            }
            return homecontactG();
          }
      ),
    );
  }
}

 */


class LoginScreenCpG extends StatefulWidget {
  const LoginScreenCpG({super.key});

  @override
  State<LoginScreenCpG> createState() => _LoginScreenCpGState();
}

class _LoginScreenCpGState extends State<LoginScreenCpG> {
  final _textEmail = TextEditingController();
  final _textPassword = TextEditingController();
  bool _isLoading = false;
  bool _passwordVisible = false;
  //Password Visibility Function
  void passwordVisibility(){
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
    Future.delayed(Duration(seconds: 2),(){
      setState(() {
        _passwordVisible = true;
      });
    });
  }

  //Sing In Function
  Future<void> _SingIn() async{
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
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.red,
            ));
      }
    }finally{
      if(mounted){
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  //Login Using Google
  Future<void> SigninGoogle()async{
    setState(() {
      _isLoading= true;
    });
    try{
      //1.start Google Sign In process
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if(googleUser==null){
        setState(() {
          _isLoading = false;
        });
        return;
      }

      //2. collect AutAuthentication From Google
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      //3. Create credential  For Fireabse
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      //4. Firebase Sign in
      await FirebaseAuth.instance.signInWithCredential(credential);

    }catch(e){
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to sign in with Google: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }

    }finally{
      if(mounted){
        setState(() {
          _isLoading = false;
        });
      }

    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Note Task'), centerTitle: true),
      body: Center(
        child: SingleChildScrollView(
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
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Sign in",style: TextStyle( color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 30 ),),
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
                              obscureText: _passwordVisible,
                              keyboardType: TextInputType.visiblePassword,
                              suffixIcon: IconButton(
                                  onPressed: passwordVisibility, 
                                  icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off)
                              ),



                            ),
                          ),
                          const SizedBox(height: 20),
                          _isLoading
                              ? const CircularProgressIndicator()
                              : Column(
                            children: [
                              OutlinedButton(onPressed: _SingIn, child: const Text("Sign in")),
                              const SizedBox(height: 30,),
                              ElevatedButton.icon(onPressed: (){
                                SigninGoogle();
                              }, label: Text("Google"),icon: Image.asset('assets/google_logo.png', height: 24.0),),



                            ],
                          ),
                          const SizedBox(height: 30,),
                          if (!_isLoading)
                            TextButton(onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpContactScreenG(),));
                            }, child: const Text("Don\'t have an account? Sign Up")),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}