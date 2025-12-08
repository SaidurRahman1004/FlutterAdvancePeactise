import 'package:flutter/cupertino.dart';

import 'counter_provider.dart';

class CounterProviderInheriteWigget extends InheritedWidget {
  final CounterProvider counterProvider; //Instance of CounterProvider

  const CounterProviderInheriteWigget({
    super.key,
    required super.child,
    required this.counterProvider,
  });

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true; // Always notify when the state changes
  }

  static CounterProviderInheriteWigget of(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<CounterProviderInheriteWigget>()!;  // Get the instance of CounterProviderInheriteWigget from the context and return it as a non-nullable value of type CounterProviderInheriteWigget.

  }
}
