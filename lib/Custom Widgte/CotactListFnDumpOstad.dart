import 'package:flutter/material.dart';
import 'InputTextFeild.dart';


void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: contactListAppDm1(),
  ));
}

class Contact{
  final String Name;
  final String Number;

  Contact({required this.Name, required this.Number});
}

class contactListAppDm1 extends StatefulWidget {
  const contactListAppDm1({super.key});

  @override
  State<contactListAppDm1> createState() => _contactListAppState();
}

class _contactListAppState extends State<contactListAppDm1> {
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
      appBar: PreferredSize(preferredSize: Size.fromHeight(100), child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: AppBar(
        title: Text("Contact List"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
          foregroundColor: Colors.white,
      ),
      )),
      body: Column(
        children: [
          Padding(padding:
          EdgeInsets.all(16.0),
            child: Column(
              children: [
                CustomTextField(controller: _nameController,labelText: "Name",),
                SizedBox(height: 10,),
                CustomTextField(controller: _numberController,keyboardType: TextInputType.phone,labelText: "Number"),
                SizedBox(height: 10,),
                ElevatedButton(onPressed: (){
                  _addContact();
                }, child: Text("Add "),style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),),

              ],
            ),
          ),
          Expanded(child: ListView.builder(
            itemCount: contacts.length,
              itemBuilder: (_,index){
                final contact = contacts[index];
                return Card(
                  elevation: 5,
                  child: ListTile(
                    leading: Icon(Icons.person, color: Colors.brown),
                    title: Text(contact.Name,style: TextStyle(fontWeight: FontWeight.bold),),
                    subtitle: Text(contact.Number),
                    trailing: Icon(Icons.call, color: Colors.blue),
                    onLongPress: () => _deleteContact(index),

                  ),

                );
              },
          ))
        ],
      ),

    );
  }
}


