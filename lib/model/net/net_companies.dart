import 'dart:convert';

import 'package:app_maquinista/model/companies.dart';
import 'package:app_maquinista/model/net/Netload.dart';
import 'package:app_maquinista/model/projectos.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;


//mas que lo mismo pero cargas las companias que van al evento 
//sebrecargamos el metode fetch_items para que lo ordene por el id de 
//la empresa por temas de relevancia
class NetCompanies extends Netload<Companies> {
  NetCompanies(int limit) :super(limit,"companiesPages","companies");

  @override
  Future<List<dynamic>> fetch_items(int page) async {
   
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
    final response = await http.get(
      Uri.parse("$serverapi/$items_endpoit/$limit/$page/idCompany"),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final decodedProjects = jsonDecode(response.body) as List;
      print(decodedProjects);
      return decodedProjects;

    } else {
      print("Ruta pag: $serverapi/$items_endpoit/$limit/$page");
      throw Exception("Error al obtener proyectos: ${response.body}");
    }
  }
  
  // Obtener página
  @override
  Future<List<Companies>> get_page(int pages) async {
    var json  = await get_items_page(pages);
    return json.map((i) => Companies.fromJson(i)).toList();
  }
}