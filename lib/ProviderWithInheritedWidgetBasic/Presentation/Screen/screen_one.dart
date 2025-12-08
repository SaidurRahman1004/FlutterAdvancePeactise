import 'package:flutter/material.dart';
import 'package:fluttert_test_code/ProviderWithInheritedWidgetBasic/Presentation/Screen/screen_two.dart';

import '../Provider/Inherite_widget.dart';

class firstCounter extends StatelessWidget {
  firstCounter({super.key});

  @override
  Widget build(BuildContext context) {
    final counterprovider = CounterProviderInheriteWigget.of(
      context,
    ).counterProvider;
    final List<Map<String, dynamic>> actions = [
      {
        "label": "Increment +",
        "onpressed": () => counterprovider.increment(),
        "color": Colors.green,
      },

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
    final count = counterprovider.counter;
    return Scaffold(
      appBar: AppBar(title: Text("First Counter")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("First Counter:", style: TextStyle(fontSize: 20)),

            const SizedBox(height: 20),

            ListenableBuilder(
              listenable: counterprovider,
              builder: (BuildContext context, Widget? child) {
                return Text(
                    counterprovider.counter.toString(),
                  style: TextStyle(
                    fontSize:17,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },

            ),
            const SizedBox(height: 20),


            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: actions.map((action) {
                return ActionChip(
                  label: Text(action['label']),
                  onPressed: action['onpressed'],
                  backgroundColor: action['color'],
                  elevation: 5,
                );
              }).toList(),
            ),

            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => secondCounter()),
                );
              },
              child: Text("go to seceond Page ->"),
            ),
          ],
        ),
      ),
    );
  }
}
