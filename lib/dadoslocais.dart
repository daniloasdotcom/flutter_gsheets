import 'package:flutter/material.dart';
import 'package:flutter_gsheets/googlesheets.dart';
import 'package:flutter_gsheets/sheetscolumn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalDataScreen extends StatefulWidget {
  const LocalDataScreen({Key? key}) : super(key: key);

  @override
  _LocalDataScreenState createState() => _LocalDataScreenState();
}

class _LocalDataScreenState extends State<LocalDataScreen> {
  List<bool> _selectedList = [];
  late Future<List<Map<String, dynamic>>> _localDataFuture;

  @override
  void initState() {
    super.initState();
    _localDataFuture = _loadLocalData();
  }

  Future<List<Map<String, dynamic>>> _loadLocalData() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> data = prefs.getStringList('localData') ?? [];
    _selectedList = List<bool>.filled(data.length, false);

    List<Map<String, dynamic>> decodedData = [];
    for (String item in data) {
      try {
        Map<String, dynamic> decodedItem = jsonDecode(item);
        decodedData.add(decodedItem);
      } catch (e) {
        print('Erro ao decodificar item: $item');
      }
    }

    return decodedData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Dados Locais', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green.shade600,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _localDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar dados.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum dado armazenado.'));
          }

          final data = snapshot.data!;
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade300, width: 1.0),
                        ),
                      ),
                      child: ListTile(
                        leading: Checkbox(
                          value: _selectedList[index],
                          onChanged: (value) {
                            setState(() {
                              _selectedList[index] = value!;
                            });
                          },
                        ),
                        title: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Tratamento: ',
                                style: TextStyle(
                                  fontFamily: 'Courier',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: '${item[SheetsColunm.tratamento]}',
                                style: TextStyle(
                                  fontFamily: 'Courier',
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                        subtitle: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Altura: ',
                                style: TextStyle(
                                  fontFamily: 'Courier',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: '${item[SheetsColunm.altura]}, ',
                                style: TextStyle(
                                  fontFamily: 'Courier',
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black87,
                                ),
                              ),
                              TextSpan(
                                text: 'Diâmetro: ',
                                style: TextStyle(
                                  fontFamily: 'Courier',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: '${item[SheetsColunm.diametro]}',
                                style: TextStyle(
                                  fontFamily: 'Courier',
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                        tileColor: Colors.grey.shade100,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    List<String> data = prefs.getStringList('localData') ?? [];
                    if (data.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Nenhum dado para enviar.')),
                      );
                      return;
                    }

                    List rows = data.map((e) => jsonDecode(e)).toList();
                    await SheetsFlutter.insert(
                        rows.cast<Map<String, dynamic>>());

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text('Dados enviados para o Google Sheets!')),
                    );
                  },
                  icon: const Icon(Icons.cloud_upload),
                  label: const Text('Enviar Dados para Google Sheets'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF417ce0),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                color: Colors.green.shade100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.red,
                      ),
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        List<String> data = prefs.getStringList('localData') ?? [];

                        List<String> newData = [];
                        for (int i = 0; i < data.length; i++) {
                          if (!_selectedList[i]) {
                            newData.add(data[i]);
                          }
                        }

                        await prefs.setStringList('localData', newData);
                        setState(() {
                          _localDataFuture = _loadLocalData();
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Dados selecionados removidos com sucesso!')),
                        );
                      },
                      child: const Text('Deletar'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.blue,
                      ),
                      onPressed: () async {
                        setState(() {
                          _selectedList = List<bool>.filled(data.length, true);
                        });
                      },
                      child: const Text('Selecionar Todos'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
