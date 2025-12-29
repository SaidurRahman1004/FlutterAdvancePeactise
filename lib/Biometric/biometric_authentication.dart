import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
void main() {
  runApp(
      MaterialApp(
        home: HomescreenAuth(),
      )
  );

}

class HomescreenAuth extends StatefulWidget {
  const HomescreenAuth({super.key});

  @override
  State<HomescreenAuth> createState() => _HomescreenAuthState();
}

class _HomescreenAuthState extends State<HomescreenAuth> {
  void _handleViewSecretNote() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const BiometricAuthentication()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF4A00E0), Color(0xFF8E2DE2)],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.white.withOpacity(0.9),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lock_outline_rounded,
                        size: 60,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      "Secret Note",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // ৩. সাব-টাইটেল
                    const Text(
                      "Please Click",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _handleViewSecretNote,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        icon: const Icon(Icons.fingerprint),
                        label: const Text(
                          "View Secret Note",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//FingerPrint Screen
class BiometricAuthentication extends StatefulWidget {
  const BiometricAuthentication({super.key});

  @override
  State<BiometricAuthentication> createState() =>
      _BiometricAuthenticationState();
}

class _BiometricAuthenticationState extends State<BiometricAuthentication> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _isBiometricAuthenticated = false;

  Future<void> _authenTicateBiometric() async {
    try {
      final bool canAuthBiometric =
      await auth.canCheckBiometrics; //cheak Biometric Support
      final bool canAuth =
          canAuthBiometric ||
              await auth
                  .isDeviceSupported(); //cheak Biometric Support Hardware and software

      if (canAuth) {
        final bool didAuth = await auth.authenticate( //Auth Dialog
          localizedReason: 'Please authenticate to view the secret note',
          biometricOnly: true,
          persistAcrossBackgrounding: true,
        );
        setState(() {
          _isBiometricAuthenticated = didAuth;
        });
        if (_isBiometricAuthenticated) {
          print('success');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SecreatNote()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Authentication failed'),
            ),
          );
        }
      }
    } catch (e) {
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Biometric Authentication"),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text('Please authenticate to view the secret note'),
            Icon(
              _isBiometricAuthenticated ? Icons.check : Icons.close,
              color: _isBiometricAuthenticated ? Colors.green : Colors.red,
              size: 50,

            ),
            const SizedBox(height: 20),
            InkWell(
              onLongPress: (){
                _authenTicateBiometric();
              },
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.deepPurple,
                child: Icon(Icons.fingerprint),
              ),
            ),


          ],
        ),

      ),
    );
  }
}


//Secreat Note
class SecreatNote extends StatelessWidget {
  const SecreatNote({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Secret Note"),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text('This is very Secreat Note'),

          ],
        ),
      ),

    );
  }
}
