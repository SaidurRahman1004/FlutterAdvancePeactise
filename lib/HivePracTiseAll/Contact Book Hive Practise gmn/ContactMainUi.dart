import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';

import 'ContactModle.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ensure Start Flutter engine
  await Hive.initFlutter(); //initial Hive
  Hive.registerAdapter(ContactModleAdapter()); // Adapter Register
  await Hive.openBox<ContactModle>("contactBox"); // Box Open
  runApp(MaterialApp(home: ContactScreen()));
}

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final Box<ContactModle>contactBoxStore = Hive.box<ContactModle>("contactBox"); //contactBoxStore যেখানে contactBox Hive এর এলিমেন্ট স্টোর করা হবে!
  final nameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  //Save Number logic
  _saveContact(){
    final enteredName = nameController.text;
    final enterdPhoneNumber = phoneNumberController.text;

    if(enteredName.isNotEmpty && enterdPhoneNumber.isNotEmpty){
      final newEnterdContact = ContactModle(name: enteredName, phoneNumber: enterdPhoneNumber);
      contactBoxStore.add(newEnterdContact);
      nameController.clear();
      phoneNumberController.clear();
      Navigator.of(context).pop();
    }
  }
  ///Contact Delet logic
  _deletContact(int index){
    contactBoxStore.deleteAt(index);
  }
  //edit Contact logic
  _editContact(int index){
    contactBoxStore.putAt(index, ContactModle(name: nameController.text, phoneNumber: phoneNumberController.text));
    nameController.clear();
    phoneNumberController.clear();
    Navigator.of(context).pop();

  }

  void dialogOptionsCustom(){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text("Input Your Contacts"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController,decoration: InputDecoration(labelText: "Enter Contact Name",hintText: "Alax,Siyam,aliba,etc.....",border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),),
            SizedBox(height: 15,),
            TextField(controller: phoneNumberController,decoration: InputDecoration(labelText: "Enter Contact Number",hintText: "Use country Code",border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),),
          ],
        ),
        actions: [
          TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text("Cencle")),
          TextButton(onPressed: (){_saveContact();}, child: Text("Save")),
        ],
      );
    });
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact Screen"),
      ),
      body: ValueListenableBuilder(
          valueListenable: contactBoxStore.listenable(), //contactBoxStore ভিতরের আইটেম অন্যযায়ী Ui আপডেট করবে!
          builder: (_,Box<ContactModle>box,_){
            if(box.isEmpty){
              return Center(child: Text("No Contact Found",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red),),);
            }
            return ListView.builder(
                itemCount: box.length,
                itemBuilder: (context,index){
                  final contactFindAccess = box.getAt(index)!;
                  return ListTile(
                    title: Text(contactFindAccess.name),
                    subtitle: Text(contactFindAccess.phoneNumber),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(onPressed: (){_deletContact(index);}, icon: Icon(Icons.delete,color: Colors.redAccent,)),
                        IconButton(onPressed: (){

                          //edit Code

                          showDialog(context: context, builder: (context){
                            return AlertDialog(
                              title: Text("Edit Your Contacts"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(controller: nameController,decoration: InputDecoration(labelText: "Enter Contact Name",hintText: "Alax,Siyam,aliba,etc.....",border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),),
                                  SizedBox(height: 15,),
                                  TextField(controller: phoneNumberController,decoration: InputDecoration(labelText: "Enter Contact Number",hintText: "Use country Code",border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),),
                                ],
                              ),
                              actions: [
                                TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text("Cencle")),
                                TextButton(onPressed: (){_editContact(index);}, child: Text("Save")),
                              ],
                            );
                          });



                        }, icon: Icon(Icons.edit,color: Colors.yellow,)),


                      ],
                    ),

                  );
                }
            );
          }
      ),
      
      floatingActionButton: FloatingActionButton(onPressed: (){dialogOptionsCustom();} ,child: Icon(Icons.add,color: Colors.redAccent,),),

    );
  }
}
