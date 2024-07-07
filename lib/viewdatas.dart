import 'dart:convert';
import 'package:http/http.dart' as http;

class Dados {
  final String tratamento;
  final double altura;
  final double diametro;

  Dados({required this.tratamento, required this.altura, required this.diametro});

  factory Dados.fromJson(Map<String, dynamic> json) {
    return Dados(
      tratamento: json['tratamento'],
      altura: double.parse(json['altura'].toString()), // Converte para double
      diametro: double.parse(json['diametro'].toString()), // Converte para double
    );
  }

  static Future<List<Dados>> fetchAll() async {
    final response = await http.get(Uri.parse(
        'https://script.google.com/macros/s/AKfycbx_-VLMTTi0mEl8CUypveg5Xsh8bzKIZJBDBQ2jafZ6ADuqGqzt1w3lJH-E-dTt1CT0/exec'));
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((data) => Dados.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<String> deleteData(String tratamento) async {
    final response = await http.post(
      Uri.parse(
          'hhttps://script.google.com/macros/s/AKfycbx_-VLMTTi0mEl8CUypveg5Xsh8bzKIZJBDBQ2jafZ6ADuqGqzt1w3lJH-E-dTt1CT0/exec'),
      body: {
        'action': 'delete',
        'tratamento': tratamento
      },
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to delete data');
    }
  }
}
