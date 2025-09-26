import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: contactListApp(),
  ));
}

class Contact{
  final String Name;
  final String Number;

  Contact({required this.Name, required this.Number});
}

class contactListApp extends StatefulWidget {
  const contactListApp({super.key});

  @override
  State<contactListApp> createState() => _contactListAppState();
}

class _contactListAppState extends State<contactListApp> {
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  List<Contact> contacts = [];
  
  //contact add function
  void _addContact(){
    final name = _nameController.text.trim();
    final number = _numberController.text.trim();
    if(name.isNotEmpty && number.isNotEmpty){
      final newContact = Contact(Name: name, Number: number);
      setState(() {
        contacts.add(newContact);
      });
      _nameController.clear();
      _numberController.clear();
    }
  }
  
  //delet Contact
  _deleteContact(int index){
    showDialog(context: context, builder: (_)=>AlertDialog(
      title: Text("Confirmation"),
      content: Text("Are you sure you want to delete this contact?"),
      actions: [
        IconButton(onPressed: (){Navigator.of(context).pop();}, icon: Icon(Icons.close, color: Colors.grey)),
        IconButton(onPressed: (){
          setState(() {
            contacts.removeAt(index);
          });
          Navigator.of(context).pop();
        }, icon: Icon(Icons.delete, color: Colors.red))
      ],
    ));

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact List"),
        centerTitle: true,
        backgroundColor: Colors.black12,
      ),
      body: Column(),

    );
  }
}


