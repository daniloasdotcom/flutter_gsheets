import 'package:flutter/material.dart';
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
    
    // Lista para armazenar os dados decodificados com sucesso
    List<Map<String, dynamic>> decodedData = [];

    // Decodificar apenas os dados válidos
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
        title: Text('Dados Locais', style: TextStyle(color: Colors.black)),
        backgroundColor: const Color.fromARGB(255, 252, 255, 68),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _localDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar dados.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum dado armazenado.'));
          }

          final data = snapshot.data!;
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];
                    return ListTile(
                      leading: Checkbox(
                        value: _selectedList[index],
                        onChanged: (value) {
                          setState(() {
                            _selectedList[index] = value!;
                          });
                        },
                      ),
                      title: Text('Tratamento: ${item[SheetsColunm.tratamento]}'),
                      subtitle: Text('Altura: ${item[SheetsColunm.altura]}, Diâmetro: ${item[SheetsColunm.diametro]}'),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
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
                        SnackBar(content: Text('Dados selecionados removidos com sucesso!')),
                      );
                    },
                    child: Text('Deletar'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _selectedList = List<bool>.filled(data.length, true);
                      });
                    },
                    child: Text('Selecionar Todos'),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
