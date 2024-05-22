import 'package:flutter/material.dart';
import 'package:flutter_gsheets/viewdatas.dart';

class DataPage extends StatefulWidget {
  const DataPage({Key? key});

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  List<Dados> _data = [];
  List<String> _selectedItems = [];
  bool _isLoading = true;
  String? _errorMessage;
  bool _selectAll = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<Dados> data = await Dados.fetchAll();
      setState(() {
        _data = data;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _errorMessage = 'Ocorreu um erro: $error';
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteSelectedData() async {
    for (String name in _selectedItems) {
      try {
        await Dados.deleteData(name);
      } catch (error) {
        print('Error deleting data: $error');
      }
    }
    _selectedItems.clear();
    _fetchData();
  }

  void _onItemChecked(String name, bool selected) {
    setState(() {
      if (selected) {
        _selectedItems.add(name);
      } else {
        _selectedItems.remove(name);
      }
    });
  }

  void _onSelectAll(bool value) {
    setState(() {
      _selectAll = value;
      if (value) {
        _selectedItems = _data.map((item) => item.tratamento).toList();
      } else {
        _selectedItems.clear();
      }
    });
  }

  String formatNumber(double number) {
    return number.toString().replaceAll('.', ',');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Lista de Dados', style: TextStyle(color: Colors.black)),
        backgroundColor: Color.fromARGB(255, 214, 216, 77)
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: _data.length,
                        itemBuilder: (context, index) {
                          final item = _data[index];
                          final isSelected =
                              _selectedItems.contains(item.tratamento);
                          return ListTile(
                            title: Text(item.tratamento),
                            subtitle: Text(
                                'Altura: ${formatNumber(item.altura)}, Diâmetro: ${formatNumber(item.diametro)}'),
                            trailing: Checkbox(
                              value: isSelected,
                              onChanged: (bool? value) {
                                if (value != null) {
                                  _onItemChecked(item.tratamento, value);
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      color: Colors.grey[600], // Cor de fundo do rodapé
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Checkbox(
                              value: _selectAll,
                              onChanged: _isLoading || _errorMessage != null
                                  ? null
                                  : (bool? value) {
                                      _onSelectAll(value!);
                                    },
                            ),
                            const Text(
                              'Selecionar Todos',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: _selectedItems.isEmpty
                                  ? null
                                  : () {
                                      _deleteSelectedData();
                                    },
                              child: const Text(
                                'Deletar Selecionados',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
