/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // এখন আমরা provider.watch ব্যবহার করছি যাতে UI স্টেট পরিবর্তন হলেও rebuild হয়
    final provider = context.watch<NameSFProvider>();
    final savedName = provider.username ?? "";
    final isEditing = provider.isEditing;

    final TextEditingController _nameController = TextEditingController(text: savedName);

    return Scaffold(
      appBar: AppBar(title: const Text('Welcome (Stateless)')),
      body: Center(
        child: isEditing
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ... (TextField এবং Save Button অপরিবর্তিত) ...
            ElevatedButton(
              onPressed: () {
                if (_nameController.text.trim().isNotEmpty) {
                  // এখন provider.changeUsername কল করলেই UI স্টেটও পরিবর্তন হবে
                  context.read<NameSFProvider>().changeUsername(_nameController.text.trim());
                }
              },
              child: Text("Save"),
            ),
          ],
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome back: $savedName",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                // provider থেকে মেথড কল করা হচ্ছে
                context.read<NameSFProvider>().toggleEditing(savedName);
              },
              child: Text("Edit"),
            ),
          ],
        ),
      ),
    );
  }
}

 */