import 'package:flutter/material.dart';

import '../Provider/Inherite_widget.dart';

class secondCounter extends StatelessWidget {
  secondCounter({super.key,});


  @override
  Widget build(BuildContext context) {
    final counterprovider = CounterProviderInheriteWigget
        .of(context)
        .counterProvider;
    final List<Map<String, dynamic>> actionsList = [
      // {
      //   "label": "Increment +",
      //   "onpressed": () => counterprovider.increment(),
      //   "color": Colors.green,
      // },

      {
        "label": "Decriment -",
        "onpressed": () => counterprovider.decrement(),
        "color": Colors.blue,
      },

      {
        "label": "Reset 0",
        "onpressed": () => counterprovider.reset(),
        "color": Colors.red,
      },
    ];


    return Scaffold(
      appBar: AppBar(
        title: Text("Second Counter"),

      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListenableBuilder(
                listenable: counterprovider, builder: (context, child) {
              return Text(
                counterprovider.counter.toString(),
                style: TextStyle(
                  fontSize: 30,

                ),
              );
            }),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: actionsList
                  .map((action) =>
                  ActionChip(label: Text(action["label"]), onPressed: action["onpressed"],backgroundColor: action['color'],))
                  .toList(),
            )

          ],
        ),
      ),

    );
  }
}