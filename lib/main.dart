/*Developer: Hugo Isaac Rodríguez Torres
  Name: Cat wight tracker.
  For: Curso para principiantes Dart+Flutter mobile apps, Sapiencia Ubicua, UDEA.
  Year: 2023
 */

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class WeightData {
  final double weight;
  final String month;
  final String range;
  final int year;

  WeightData(this.weight, this.month, this.range, this.year);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cat Weight Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CatWeightTracker(),
    );
  }
}

class CatWeightTracker extends StatefulWidget {
  @override
  _CatWeightTrackerState createState() => _CatWeightTrackerState();
}

class _CatWeightTrackerState extends State<CatWeightTracker> {
  TextEditingController weightController = TextEditingController();
  TextEditingController monthController = TextEditingController();
  TextEditingController yearController = TextEditingController();

  double weight = 0.0;
  String month = '';
  String weightStatus = 'Normal';
  int year = DateTime.now().year;
  List<WeightData> weightHistory = [];

  void updateWeightStatus() {
    if (weight < 3.0) {
      setState(() {
        weightStatus = 'Bajo peso';
      });
    } else if (weight >= 3.0 && weight <= 6.0) {
      setState(() {
        weightStatus = 'Peso normal';
      });
    } else {
      setState(() {
        weightStatus = 'Obesidad mórbida';
      });
    }
  }

  void clearControllers() {
    weightController.clear();
    monthController.clear();
    yearController.clear();
  }

  bool isValidMonth(String value) {
    final validMonths = [
      'enero', 'febrero', 'marzo', 'abril',
      'mayo', 'junio', 'julio', 'agosto',
      'septiembre', 'octubre', 'noviembre', 'diciembre'
    ];
    return validMonths.contains(value.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cat Weight Tracker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Peso de la gata (kg):',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              '$weight',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Mes: $month',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Año: $year',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Ingresar Peso'),
                      content: Column(
                        children: <Widget>[
                          TextField(
                            controller: weightController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(labelText: 'Peso (kg)'),
                          ),
                          TextField(
                            controller: monthController,
                            decoration: InputDecoration(labelText: 'Mes'),
                          ),
                          TextField(
                            controller: yearController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(labelText: 'Año'),
                          ),
                        ],
                      ),
                      actions: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            if (weightController.text.isNotEmpty && monthController.text.isNotEmpty && yearController.text.isNotEmpty) {
                              weight = double.tryParse(weightController.text) ?? 0.0;
                              month = monthController.text;
                              year = int.tryParse(yearController.text) ?? DateTime.now().year;
                              if (weight > 0 && year > 0 && isValidMonth(month)) {
                                updateWeightStatus();
                                weightHistory.add(WeightData(weight, month, weightStatus, year));
                                clearControllers();
                                Navigator.of(context).pop();
                              } else {
                                // Mostrar un diálogo de entrada no válida
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Entrada no válida'),
                                      content: Text('Por favor, ingrese datos válidos.'),
                                      actions: <Widget>[
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Aceptar'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            }
                          },
                          child: Text('Guardar'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Ingresar Peso'),
            ),
            SizedBox(height: 20),
            Text(
              'Estado del peso:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              weightStatus,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: weightStatus == 'Obesidad mórbida'
                    ? Colors.red
                    : weightStatus == 'Peso normal'
                    ? Colors.green
                    : Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Historial de Pesos:',
              style: TextStyle(fontSize: 18),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: weightHistory.length,
                itemBuilder: (context, index) {
                  final data = weightHistory[index];
                  return ListTile(
                    title: Text('Peso: ${data.weight} kg'),
                    subtitle: Text(
                      'Mes: ${data.month}\nAño: ${data.year}\nRango: ${data.range}',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}