import 'package:flutter/material.dart';
import 'package:fluttert_test_code/ProviderWithInheritedWidgetBasic/Presentation/Screen/screen_two.dart';

import '../Provider/Inherite_widget.dart';

class firstCounter extends StatelessWidget {

   firstCounter({super.key});


  final List<Map<String, dynamic>> actions =[
    {
      "label":"Increment +",
     // "onpressed" => counterprovider.incriment();

      "color":Colors.green
    }

  ];


  @override
  Widget build(BuildContext context) {
    final counterprovider = CounterProviderInheriteWigget.of(context).counterProvider;
    final count = counterprovider.counter;
    return Scaffold(
      appBar: AppBar(
        title: Text("First Counter"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("First Counter:",style: TextStyle(
              fontSize: 20
            ),),

            const SizedBox(height: 20,),

            Text("Count: ",
              style: TextStyle(
                fontSize: 15
            ),),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //
              ],

            ),

            const SizedBox(height: 20,),
            TextButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (_)=>secondCounter()));
            }, child: Text("go to seceond Page"))



          ],
        ),
      ),

    );
  }
}
