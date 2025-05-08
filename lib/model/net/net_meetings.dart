import 'dart:convert';

import 'package:app_maquinista/model/companies.dart';
import 'package:app_maquinista/model/meetings.dart';
import 'package:app_maquinista/model/net/Netload.dart';
import 'package:app_maquinista/model/projectos.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;


//carga de las ponecas el funcionamento es el mismo sobre cargamos 
//el metodo fetch items paara que las ponecias se ordenen por hora
class NetMeetings extends Netload<Meetings> {
  NetMeetings(int limit) :super(limit,"presentationsPages","presentations");

  @override
  Future<List> fetch_items(int page) async {
     
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
    final response = await http.get(
      Uri.parse("$serverapi/$items_endpoit/$limit/$page/presentationDate"),
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
  Future<List<Meetings>> get_page(int pages) async {
    var json  = await get_items_page(pages);
    return json.map((i) => Meetings.fromjson(i)).toList();
  }
}