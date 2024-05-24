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
  final FocusNode alturaFocusNode = FocusNode();
  final FocusNode diametroFocusNode = FocusNode();
  String? selectedTratamento;
  bool isFormAlmostFilled = false;

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

  void checkFormAlmostFilled() {
    setState(() {
      int filledCount = 0;
      if (alturaController.text.isNotEmpty) filledCount++;
      if (diametroController.text.isNotEmpty) filledCount++;
      if (selectedTratamento != null) filledCount++;

      isFormAlmostFilled = filledCount >= 2;
    });
  }

  @override
  void initState() {
    super.initState();
    alturaController.addListener(checkFormAlmostFilled);
    diametroController.addListener(checkFormAlmostFilled);
    alturaFocusNode.addListener(() {
      setState(() {});
    });
    diametroFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    alturaController.removeListener(checkFormAlmostFilled);
    diametroController.removeListener(checkFormAlmostFilled);
    alturaFocusNode.dispose();
    diametroFocusNode.dispose();
    alturaController.dispose();
    diametroController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Coletor de dados',
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF417ce0),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    alturaController.clear();
                    diametroController.clear();
                    setState(() {
                      selectedTratamento = null;
                      isFormAlmostFilled = false;
                    });
                  },
                  icon: const Icon(Icons.cleaning_services),
                  label: const Text('Limpar Formulário'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF417ce0),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Tratamento',
                    filled: true,
                    fillColor: selectedTratamento != null
                        ? Colors.grey[200]
                        : Colors.white,
                    border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedTratamento,
                      hint: const Text('Selecione o Tratamento'),
                      isExpanded: true,
                      items: tratamentoOptions
                          .map((tratamento) => DropdownMenuItem<String>(
                                value: tratamento,
                                child: Text(tratamento),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedTratamento = value;
                          checkFormAlmostFilled();
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  controller: alturaController,
                  focusNode: alturaFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Altura',
                    labelStyle: TextStyle(
                      color:
                          alturaFocusNode.hasFocus ? Colors.red : Colors.grey,
                    ),
                    filled: true,
                    fillColor: alturaFocusNode.hasFocus ||
                            alturaController.text.isNotEmpty
                        ? Colors.grey[200]
                        : Colors.white,
                    border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
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
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  controller: diametroController,
                  focusNode: diametroFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Diâmetro',
                    labelStyle: TextStyle(
                      color: diametroFocusNode.hasFocus ? Colors.red : Colors.grey,
                    ),
                    filled: true,
                    fillColor: diametroFocusNode.hasFocus ||
                            diametroController.text.isNotEmpty
                        ? Colors.grey[200]
                        : Colors.white,
                    border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
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
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ElevatedButton.icon(
                  onPressed: isFormAlmostFilled
                      ? () async {
                          if (selectedTratamento == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Por favor, selecione um tratamento.')),
                            );
                            return;
                          }

                          final feedback = {
                            SheetsColunm.tratamento: selectedTratamento!,
                            SheetsColunm.altura: double.tryParse(
                                    alturaController.text
                                        .replaceAll(',', '.')) ??
                                0.0,
                            SheetsColunm.diametro: double.tryParse(
                                    diametroController.text
                                        .replaceAll(',', '.')) ??
                                0.0,
                          };

                          // Save locally
                          final prefs = await SharedPreferences.getInstance();
                          List<String> data =
                              prefs.getStringList('localData') ?? [];
                          data.add(jsonEncode(feedback));
                          await prefs.setStringList('localData', data);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Dados armazenados localmente!')),
                          );
                          alturaController.clear();
                          diametroController.clear();
                          setState(() {
                            selectedTratamento = null;
                            isFormAlmostFilled = false;
                          });
                        }
                      : null,
                  icon: const Icon(Icons.save),
                  label: const Text('Salvar Dados Localmente'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor:
                        isFormAlmostFilled ? Colors.green : Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LocalDataScreen()),
                    );
                  },
                  icon: const Icon(Icons.storage),
                  label: const Text('Ver Dados Locais'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF417ce0),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DataPage()),
                    );
                  },
                  icon: const Icon(Icons.view_list),
                  label: const Text('Ver Dados no Google Sheets'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF417ce0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
