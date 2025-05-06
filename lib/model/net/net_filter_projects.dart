import 'dart:convert'; // Para convertir datos JSON.

import 'package:app_maquinista/model/net/Netload.dart'; // Clase base para cargar datos de red.
import 'package:app_maquinista/model/projectos.dart'; // Modelo del objeto Proyecto.
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Para usar variables de entorno (.env).
import 'package:http/http.dart' as http; // Cliente HTTP para realizar peticiones a una API.

// Clase para cargar proyectos desde la API, filtrando según parámetros dados.
// Hereda de Netload con tipo Proyecto.
class NetFilterProjects extends Netload<Proyecto> {
  // Variables para indicar el campo por el cual filtrar y el valor a filtrar.
  String where = "";
  String value = "";

  // Constructor que llama al constructor de la clase base Netload.
  // Se le pasa el límite de resultados, el nombre del endpoint de páginas, y el de items.
  NetFilterProjects(int limit)
      : super(limit, "projectsFilterPages", "projects");

  // Método que obtiene una lista de items (proyectos) desde el servidor, según la página dada.
  @override
  Future<List> fetch_items(int page) async {
    // Cabeceras HTTP necesarias para la petición (tipo de contenido, autorización, etc.).
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token", // Usa el token definido globalmente.
    };

    // Se realiza la petición GET a la API.
    final response = await http.get(
      Uri.parse(
        "$serverapi/$items_endpoit/${limit.toString()}/$page/$where/$value"
      ),
      headers: headers,
    );

    // Si la respuesta es exitosa (código 200):
    if (response.statusCode == 200) {
      final decodedProjects = jsonDecode(response.body) as List;
      print(decodedProjects); // Se imprime para debug.
      return decodedProjects; // Se devuelve la lista de proyectos decodificada.
    } else {
      // Si ocurre un error, imprime la URL usada y lanza una excepción con el cuerpo del error.
      print("Ruta pag: $serverapi/$items_endpoit/$limit/$page/$where/$value");
      throw Exception("Error al obtener proyectos: ${response.body}");
    }
  }

  // Método para obtener el número total de páginas que hay, según el filtro aplicado.
  @override
  Future<int> fetch_pages() async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };

    // Se hace una petición GET al endpoint que devuelve el número total de páginas.
    final response = await http.get(
      Uri.parse("$serverapi/$pages_endpoint/${limit.toString()}/$where/$value"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return int.parse(response.body); // Se convierte la respuesta en entero.
    } else {
      throw Exception("Error al obtener páginas: ${response.body}");
    }
  }

  // Método para obtener una página específica y transformarla en una lista de objetos Proyecto.
  @override
  Future<List<Proyecto>> get_page(int pages) async {
    var json = await get_items_page(pages); // Llama a la función que obtiene los datos crudos.
    return json.map((i) => Proyecto.fromJson(i, server)).toList(); // Se transforma cada item JSON en un objeto Proyecto.
  }
}