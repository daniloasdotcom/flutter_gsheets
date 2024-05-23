import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gsheets/dadoslocais.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gsheets/dataspages.dart';
import 'package:flutter_gsheets/googlesheets.dart';
import 'package:flutter_gsheets/sheetscolumn.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController alturaController = TextEditingController();
  final TextEditingController diametroController = TextEditingController();
  String? selectedTratamento;

  final List<String> tratamentoOptions = [
    'T1D0R1',
    'T2D0R2',
    'T3D0R3',
    'T5D0R4',
    'T5D0R5',
    'ID2,5R1',
    'ID2,5R2',
    'ID2,5R3',
    'ID2,5R4',
    'ID2,5R5',
    'ID5R1',
    'ID5R2',
    'ID5R3',
    'ID5R4',
    'ID5R5',
    'ID7,5R1',
    'ID7,5R2',
    'ID7,5R3',
    'ID7,5R4',
    'ID7,5R5',
    'NID2,5R1',
    'NID2,5R2',
    'NID2,5R3',
    'NID2,5R4',
    'NID2,5R5',
    'NID5R1',
    'NID5R2',
    'NID5R3',
    'NID5R4',
    'NID5R5',
    'NID7,5R1',
    'NID7,5R2',
    'NID7,5R3',
    'NID7,5R4',
    'NID7,5R5'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Coletor de dados', style: TextStyle(color: Colors.black)),
        backgroundColor: const Color.fromARGB(255, 252, 255, 68),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: DropdownButtonFormField<String>(
                  value: selectedTratamento,
                  hint: const Text('Selecione o Tratamento'),
                  isExpanded: true,
                  dropdownColor: const Color.fromARGB(255, 177, 120, 120),
                  decoration: const InputDecoration(
                    labelText: 'Tratamento',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent),
                    ),
                  ),
                  items: tratamentoOptions
                      .map((tratamento) => DropdownMenuItem<String>(
                            value: tratamento,
                            child: Text(tratamento),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedTratamento = value;
                    });
                  },
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: alturaController,
                decoration: InputDecoration(
                  labelText: 'Altura',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*[.,]?\d*$')),
                  TextInputFormatter.withFunction((oldValue, newValue) {
                    if (newValue.text.contains(',')) {
                      return TextEditingValue(
                        text: newValue.text.replaceAll(',', '.'),
                        selection: newValue.selection,
                      );
                    }
                    return newValue;
                  }),
                ],
              ),
              SizedBox(height: 16),
              TextField(
                controller: diametroController,
                decoration: InputDecoration(
                  labelText: 'Diâmetro',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*[.,]?\d*$')),
                  TextInputFormatter.withFunction((oldValue, newValue) {
                    if (newValue.text.contains(',')) {
                      return TextEditingValue(
                        text: newValue.text.replaceAll(',', '.'),
                        selection: newValue.selection,
                      );
                    }
                    return newValue;
                  }),
                ],
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (selectedTratamento == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Por favor, selecione um tratamento.')),
                    );
                    return;
                  }

                  final feedback = {
                    SheetsColunm.tratamento: selectedTratamento!,
                    SheetsColunm.altura: double.tryParse(
                            alturaController.text.replaceAll(',', '.')) ?? 0.0,
                    SheetsColunm.diametro: double.tryParse(
                            diametroController.text.replaceAll(',', '.')) ?? 0.0,
                  };

                  // Save locally
                  final prefs = await SharedPreferences.getInstance();
                  List<String> data = prefs.getStringList('localData') ?? [];
                  data.add(jsonEncode(feedback));
                  await prefs.setStringList('localData', data);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Dados armazenados localmente!')),
                  );
                  alturaController.clear();
                  diametroController.clear();
                  setState(() {
                    selectedTratamento = null;
                  });
                },
                child: Text('Salvar Dados Localmente'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Color.fromARGB(255, 214, 216, 77),
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LocalDataScreen()),
                  );
                },
                child: Text('Ver Dados Locais'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Color.fromARGB(255, 214, 216, 77),
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  List<String> data = prefs.getStringList('localData') ?? [];
                  if (data.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Nenhum dado para enviar.')),
                    );
                    return;
                  }

                  List rows = data.map((e) => jsonDecode(e)).toList();
                  await SheetsFlutter.insert(rows.cast<Map<String, dynamic>>());

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Dados enviados para o Google Sheets!')),
                  );
                },
                child: Text('Enviar Dados para Google Sheets'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Color.fromARGB(255, 214, 216, 77),
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  alturaController.clear();
                  diametroController.clear();
                  setState(() {
                    selectedTratamento = null;
                  });
                },
                child: Text('Limpar Campos'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Color.fromARGB(255, 214, 216, 77),
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DataPage()),
                  );
                },
                child: Text('Ver Dados Locais'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Color.fromARGB(255, 214, 216, 77),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
