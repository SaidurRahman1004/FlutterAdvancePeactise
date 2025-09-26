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
    {"name": "Jawad", "number": "01877-777777"},
    {"name": "Ferdous", "number": "01677-777777"},
    {"name": "Hasan", "number": "01745-777777"},
    {"name": "Hasan", "number": "01745-777777"},
    {"name": "Hasan", "number": "01745-777777"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact List"),
        centerTitle: true,
        backgroundColor: Colors.black12,
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
                ElevatedButton(onPressed: (){}, child: Text("Add Contact")),
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


