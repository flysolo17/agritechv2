import 'package:agritechv2/styles/color_styles.dart';
import 'package:agritechv2/views/custom%20widgets/button.dart';
import 'package:flutter/material.dart';

class CalulatorPage extends StatefulWidget {
  const CalulatorPage({super.key});

  @override
  State<CalulatorPage> createState() => _CalulatorPageState();
}

class _CalulatorPageState extends State<CalulatorPage> {
  final TextEditingController _controllerTotalPopulation =
      TextEditingController(text: '0.00');
  final TextEditingController _controllerPlantInMeters =
      TextEditingController();
  final TextEditingController _controllerRowInMeters = TextEditingController();
  final TextEditingController _controllerLandArea = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void calculateTotalPoplutaion() {
    if (_formKey.currentState!.validate()) {
      final double plant = double.tryParse(_controllerPlantInMeters.text) ?? 0;
      final double row = double.tryParse(_controllerRowInMeters.text) ?? 0;
      final double land = double.tryParse(_controllerLandArea.text) ?? 0;

      if (plant > 0 && row > 0) {
        _controllerTotalPopulation.text =
            (land / (row * plant)).toStringAsFixed(2);
      } else {
        _controllerTotalPopulation.text = 'N/A';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
        backgroundColor: ColorStyle.brandRed,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _controllerTotalPopulation,
                    readOnly: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Total Population',

                      // prefixIcon: Icon(Icons.search), // Icon before the input
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _controllerPlantInMeters,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Field is required';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Plant to Plant in meters',
                      hintText: '0.5',
                      helperText: 'Plant to Plant in meters',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _controllerRowInMeters,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Field is required';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Row to Row in meters',
                      hintText: '0.5',
                      helperText: 'Row to Row in meters',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _controllerLandArea,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Field is required';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Land Area in meters',
                      hintText: '100',
                      helperText: 'Land area in meters',
                    ),
                  ),
                ),
                Button(
                  onTap: () => calculateTotalPoplutaion(),
                  buttonText: "Calculate",
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
