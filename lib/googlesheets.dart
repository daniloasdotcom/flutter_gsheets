// Importação de pacotes necessários para a funcionalidade do Google Sheets

// Classe SheetsFlutter para gerenciar interações com uma planilha do Google Sheets
import 'package:flutter_sheets/sheetscolumn.dart';
import 'package:gsheets/gsheets.dart';

class SheetsFlutter {

  // ID da planilha do Google Sheets (deve ser configurado com o ID real da sua planilha)
  static const String _sheetId = "";
  // Credenciais da API do Google Sheets (JSON de credenciais deve ser colocado aqui)
  static const _sheetCredentials = r'''
  {
  }
''';


  // Worksheet (aba da planilha) para armazenar os dados do usuário
  static Worksheet? _userSheet;
  
  // Instância da classe GSheets inicializada com as credenciais
  static final _gsheets = GSheets(_sheetCredentials);

  // Método de inicialização assíncrono para configurar a planilha e a aba
  static Future init() async {
    try{
    // Obtém a planilha usando o ID configurado
    final spreadsheet = await _gsheets.spreadsheet(_sheetId);
    
    // Obtém ou cria a aba (Worksheet) com o título "Feed"
    _userSheet = await _getWorkSheet(spreadsheet, title: "Feed");

    // Insere a primeira linha com os nomes das colunas
    final firstRow = SheetsColunm.getColumns(); // Obtém os nomes das colunas de SheetsColunm
    _userSheet!.values.insertRow(1, firstRow); // Insere a primeira linha na aba
    } catch(e) {
      // Captura e imprime qualquer erro que ocorrer durante a inicialização
      print(e);

    }
  }


  // Método privado para obter ou criar uma Worksheet (aba) na planilha
  static Future<Worksheet> _getWorkSheet(
      Spreadsheet spreadsheet,{
        required String title,
      }) async {
    try{
      // Tenta adicionar uma nova aba com o título especificado
      return await spreadsheet.addWorksheet(title);
      } catch(e) {
      // Se a aba já existir, retorna a aba existente com o título especificado
      return spreadsheet.worksheetByTitle(title)!;
      }
    }

    // Método para inserir uma lista de linhas na aba do usuário
    static Future insert(List<Map<String, dynamic>> rowList) async{
      // Mapeia e adiciona as linhas na aba (_userSheet)
      _userSheet!.values.map.appendRows(rowList);
    }
}
