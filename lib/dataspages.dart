import 'package:flutter/material.dart';
import 'package:flutter_gsheets/viewdatas.dart';

class DataPage extends StatefulWidget {
  const DataPage({Key? key});

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  List<Dados> _data = [];
  List<int> _selectedIndices = [];
  bool _isLoading = true;
  String? _errorMessage;
  bool _selectAll = false;
  bool _isDeleting = false; // Variável para indicar se está ocorrendo a exclusão

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
    setState(() {
      _isDeleting = true; // Marca como processo de exclusão iniciado
    });
    for (int index in _selectedIndices) {
      try {
        await Dados.deleteData(_data[index].tratamento);
      } catch (error) {
        print('Error deleting data: $error');
      }
    }
    _selectedIndices.clear();
    _fetchData();
    setState(() {
      _isDeleting = false; // Marca como processo de exclusão concluído
    });
  }

  void _onItemChecked(int index, bool selected) {
    setState(() {
      if (selected) {
        _selectedIndices.add(index);
      } else {
        _selectedIndices.remove(index);
      }
    });
  }

  void _onSelectAll(bool value) {
    setState(() {
      _selectAll = value;
      if (value) {
        _selectedIndices = List.generate(_data.length, (index) => index);
      } else {
        _selectedIndices.clear();
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
        title: const Text('Lista de Dados', style: TextStyle(color: Colors.black)),
        backgroundColor: Color.fromARGB(255, 214, 216, 77)
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: DataTable(
                      headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey[200]!),
                      headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                      columnSpacing: 8,
                      dataRowColor: MaterialStateColor.resolveWith((states) => Colors.grey[100]!),
                      columns: [
                        DataColumn(label: Text('Tratamento')),
                        DataColumn(label: Text('Altura')),
                        DataColumn(label: Text('Diâmetro')),
                      ],
                      rows: _data
                          .asMap()
                          .entries
                          .map(
                            (entry) => DataRow(
                              color: MaterialStateColor.resolveWith(
                                (states) => _selectedIndices.contains(entry.key) ? Colors.blue[100]! : Colors.transparent,
                              ),
                              cells: [
                                DataCell(Text(entry.value.tratamento)),
                                DataCell(Text(formatNumber(entry.value.altura))),
                                DataCell(Text(formatNumber(entry.value.diametro))),
                              ],
                              selected: _selectedIndices.contains(entry.key),
                              onSelectChanged: (selected) {
                                _onItemChecked(entry.key, selected!);
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
      bottomNavigationBar: BottomAppBar(
        color: Color.fromARGB(255, 214, 216, 77),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: _selectAll,
                    onChanged: _isLoading || _errorMessage != null
                        ? null
                        : (bool? value) {
                            _onSelectAll(value!);
                          },
                  ),
                  Text(
                    'Selecionar Todos',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: _selectedIndices.isEmpty
                    ? null
                    : () {
                        _deleteSelectedData();
                      },
                child: Row(
                  children: [
                    const Text(
                      'Deletar',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                    if (_isDeleting) // Se estiver deletando, exibe a mensagem
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
