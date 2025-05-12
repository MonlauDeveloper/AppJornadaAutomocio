import 'dart:convert';

import 'package:app_maquinista/model/net/Netload.dart';
import 'package:app_maquinista/model/projectos.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;


//clase para cargar los projectos tanto normales como monlautech
//pero con campos adicionales para establecer filtros
class NetFilterProjects extends Netload<Proyecto> {
  String where="";//campo por el qual filtrar
  String value = ""; //valor del campo de los elemntos deseados
  //lo demas funciona como cualquier objecto netload fetch_items caarga los objectos aplicando el filtro desde la api
  //fetch_pages consulta la cantidad de paginas de la consulta con el filtro
  NetFilterProjects(int limit):
    super(limit,"projectsFilterPages","projects");

  @override
  Future<List> fetch_items(int page) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
    final response = await http.get(
      Uri.parse("$serverapi/$items_endpoit/"+limit.toString()+"/$page/$where/$value"),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final decodedProjects = jsonDecode(response.body) as List;
      print(decodedProjects);
      return decodedProjects;

    } else {
      print("Ruta pag: $serverapi/$items_endpoit/$limit/$page/$where/$value");
      throw Exception("Error al obtener proyectos: ${response.body}");
    }
  }


  @override
  Future<int> fetch_pages() async{
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
    final response = await http.get(
        Uri.parse( "$serverapi/$pages_endpoint/"+limit.toString()+"/$where/$value"),

        headers: headers
    );
    if (response.statusCode == 200) {
      
      return int.parse(response.body);
    } else {
      throw Exception("Error al obtener páginas: ${response.body}");
    }
  }
  // Obtener página
  @override
  //implementación de la función para transformar json a proyectos.
  Future<List<Proyecto>> get_page(int pages) async {
    var json  = await get_items_page(pages);
    return json.map((i) => Proyecto.fromJson(i, server)).toList();
  }
}