import 'package:app_maquinista/custom_widgets/Pdfview.dart';
import 'package:app_maquinista/custom_widgets/cv_card.dart';
import 'package:app_maquinista/custom_widgets/cv_pdf_view.dart';
import 'package:app_maquinista/model/projectos.dart';
import 'package:app_maquinista/projectos_detalles_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Widget principal que recibe un objeto Proyecto como parámetro.
class ProjectIndividualLayout extends StatefulWidget {
  final Proyecto project;
  const ProjectIndividualLayout({super.key, required this.project});

  @override
  ProjectIndividualLayoutState createState() =>
      ProjectIndividualLayoutState();
}

// Estado del widget con soporte para animaciones (gracias a SingleTickerProviderStateMixin)
class ProjectIndividualLayoutState extends State<ProjectIndividualLayout>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Inicializa un controlador para las tres pestañas.
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose(); // Libera recursos al destruirse
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Estructura principal de la interfaz
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Sección de video del proyecto
            SizedBox(
              height: 300,
              child: _buildVideoSection(),
            ),
            // Pestañas para cambiar entre secciones
            TabBar(
              controller: _tabController,
              indicatorColor: Colors.blue,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: widget.project.Titulo), // Título como primera pestaña
                Tab(text: "Memoria"),
                Tab(text: "Autores"),
              ],
            ),
            // Contenido de cada pestaña
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildDetailsSection(),
                  _buildMemorySection(),
                  _buildAuthorsSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Construye la sección de video (si es un enlace de YouTube)
  Widget _buildVideoSection() {
    if (widget.project.VideoUrl.contains("youtube.com")) {
      return Ytvideo(
        videoUrl: widget.project.VideoUrl,
        is_muted: false,
      );
    } else {
      // Si no hay video válido, muestra un ícono
      return const Icon(Icons.videocam_off, size: 150);
    }
  }

  // Construye la sección de detalles del proyecto
  Widget _buildDetailsSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Título centrado
          Align(
            alignment: Alignment.center,
            child: Text(
              widget.project.Titulo,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 25),
          // Descripción del proyecto
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Descripción del proyecto",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.project.Resumen,
                  textAlign: TextAlign.justify,
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          // Información sobre el tribunal evaluador
          Row(
            children: [
              const Icon(Icons.account_balance, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Número de tribunal",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    Text(widget.project.Box),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          // Botón para evaluar el proyecto
          ElevatedButton(
            onPressed: _goToEvaluate,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            child: const Text("Evaluar Proyecto"),
          ),
        ],
      ),
    );
  }

  // Construye la sección de memoria en PDF
  Widget _buildMemorySection() {
    try {
      return PDFview(url: widget.project.MemoriaUrl);
    } catch (e) {
      // Si hay error al cargar el PDF
      return Center(child: Text("Error al cargar PDF: ${e.toString()}"));
    }
  }

  // Construye la sección de autores
  Widget _buildAuthorsSection() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(15.0),
              itemCount: widget.project.Autor.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    // Al pulsar un autor, muestra su CV en un PDF
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CvPdfView(
                          url: widget.project.Autor[index].cvLink,
                        );
                      },
                    );
                  },
                  // Muestra la tarjeta del autor
                  child: CVCard(
                    imagePath: widget.project.Autor[index].photoName,
                    name: widget.project.Autor[index].get_all_name(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Método para lanzar la URL de evaluación en el navegador
  Future<void> _goToEvaluate() async {
    try {
      final Uri url = Uri.parse(widget.project.UrlEvaluation);
      if (!await launchUrl(url)) {
        throw Exception("No se pudo abrir la URL");
      }
    } catch (e) {
      // Si falla, muestra un mensaje en pantalla
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }
}
