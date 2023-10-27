import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:textformfield_unit/textformfield_unit.dart';

enum SizeUnits { Millimeter, Inch, LightNanosecond }

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TextFormFieldUnit Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static final unitNames = {
    SizeUnits.Millimeter: 'mm',
    SizeUnits.Inch: '"',
    SizeUnits.LightNanosecond: 'light-ns',
  };
  final formKey = GlobalKey<FormState>();
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: NumberFormat.decimalPattern().format(156.25));
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  double _sizeConverter(SizeUnits fromUnit, SizeUnits toUnit, double value) {
    final valueMm = switch (fromUnit) {
      SizeUnits.Millimeter => value,
      SizeUnits.Inch => value * 25.4,
      SizeUnits.LightNanosecond => value * 299.792458,
    };
    return switch (toUnit) {
      SizeUnits.Millimeter => valueMm,
      SizeUnits.Inch => valueMm / 25.4,
      SizeUnits.LightNanosecond => valueMm / 299.792458,
    };
  }

  @override
  Widget build(BuildContext context) {
    final allowed = switch (NumberFormat().symbols.DECIMAL_SEP) {
      '.' => RegExp(r'[\d.]'),
      ',' => RegExp(r'[\d,]'),
      _ => RegExp(r'\d'),
    };

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormUnitField<SizeUnits>(
                      controller: controller,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.allow(allowed)],
                      textInputAction: TextInputAction.next,
                      icon: const Icon(Icons.height),
                      labelText: 'Size',
                      units: unitNames,
                      initialUnit: SizeUnits.Millimeter,
                      unitIcon: const Icon(Icons.keyboard_arrow_down),
                      converter: _sizeConverter,
                      onSaved: (value) {
                        if (value != null) print('${value.value} ${unitNames[value.unit]}');
                      },
                    ),
                  ],
                )),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
