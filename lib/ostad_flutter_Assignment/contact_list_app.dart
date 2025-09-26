import 'package:flutter/material.dart';

import 'custom_text_feild.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: contactListApp(),
  ));
}



class contactListApp extends StatefulWidget {
  const contactListApp({super.key});

  @override
  State<contactListApp> createState() => _contactListAppState();
}

class _contactListAppState extends State<contactListApp> {
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  final List<Map<String, String>> contacts = const [
    {"name": "Siyam", "number": "01745-777777"},
    {"name": "Jawad", "number": "01877-777777"},
    {"name": "Ferdous", "number": "01677-777777"},
    {"name": "Hasan", "number": "01745-777777"},
    {"name": "Hasan", "number": "01745-777777"},
    {"name": "Hasan", "number": "01745-777777"},
    {"name": "Saidur", "number": "01745-777777"}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100), // AppBar height increase
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),  // বাঁ দিকে curve
              topRight: Radius.circular(20), // ডান দিকে curve
            ),
            child: AppBar(
              backgroundColor: Colors.blueGrey,
              centerTitle: true,
              title: const Text(
                "Contact List",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color: Colors.white),
              ),
            ),
          ),
        ),
      body: Column(
        children: [
          Padding(padding: 
          EdgeInsets.all(16.0),
            child: Column(
              children: [
                CustomTextFieldos(controller: _nameController,labelText: "Name",),
                SizedBox(height: 10,),
                CustomTextFieldos(controller: _numberController,keyboardType: TextInputType.phone,labelText: "Number",),
                SizedBox(height: 10,),
                ElevatedButton(onPressed: (){}, child: Text("Add "),style: ElevatedButton.styleFrom(
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
                    title: Text(contact["name"] ?? "",style: TextStyle(                        color: Colors.red,
                      fontWeight: FontWeight.bold,),),
                    subtitle: Text(contact["number"] ?? ""),
                    trailing: Icon(Icons.call, color: Colors.blue),
                  ),
                );

              },
          ))
        ],
      ),

    );
  }
}


