import 'dart:io';
import 'package:app_maquinista/custom_widgets/pop_up_speaker_card.dart';
import 'package:app_maquinista/custom_widgets/custom_card.dart';
import 'package:app_maquinista/custom_widgets/line_painter.dart';
import 'package:app_maquinista/project_individual_layout.dart';
import 'package:app_maquinista/exhibitors_layout.dart';
import 'package:app_maquinista/map_layout.dart';
import 'package:app_maquinista/projectos_detalles_page.dart';
import 'package:app_maquinista/projects_layout.dart';
import 'package:app_maquinista/speakers_layout.dart';
import 'package:app_maquinista/title_section.dart';
import 'package:app_maquinista/model/companies.dart';
import 'package:app_maquinista/model/dinamicTest.dart';
import 'package:app_maquinista/model/meetings.dart';
import 'package:app_maquinista/model/net/http_overwide.dart';
import 'package:app_maquinista/model/net/net_companies.dart';
import 'package:app_maquinista/model/net/net_meetings.dart';
import 'package:app_maquinista/model/net/net_projects.dart';
import 'package:app_maquinista/model/net/net_monlautech.dart';
import 'package:app_maquinista/model/projectos.dart';
import 'package:flutter/material.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monlau MotorSport',
      theme: ThemeData(
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.white,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

List<Proyecto> projectos = [];
List<Meetings> meets = [];
List<DinamicTest> testdinamicos = [];
List<DinamicTest> monlautech = [];
List<Companies> companies = [];

NetProjects proj_mng = NetProjects(10, "projectsPages", "projects");
NetMonalautech mont_mng = NetMonalautech(10);
NetCompanies com_mng = NetCompanies(70);
NetMeetings met_mng = NetMeetings(70);

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<int> load() async {
    projectos = await proj_mng.get_page(1);
    monlautech = await mont_mng.get_page(1);
    companies = await com_mng.get_page(1);
    meets = await met_mng.get_page(1);
    return 1;
  }

  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  late Future<void> _loadFuture;

  @override
  void initState() {
    super.initState();
    _loadFuture = load();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadFuture, // Future que carga los datos iniciales
      builder: (context, snapshot) {
        // Estado de carga: muestra un indicador circular
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        // Estado de error: muestra el mensaje de error
        else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }
        // Estado completado: muestra el contenido principal
        else {
          return Scaffold(
            body: PageView(
              controller: _pageController, // Controlador para el PageView
              physics: const NeverScrollableScrollPhysics(), // Desactiva el scroll manual
              children: [
                _homeScreen(), // Pantalla de inicio
                ProjectsLayout( // Vista de proyectos
                  projects: projectos,
                  proj_mng: proj_mng,
                  monlauTech_mng: mont_mng,
                  monlauTechPrj: monlautech,
                ),
                MapLayout(), // Vista del mapa
                SpeakersLayout(ponencias: meets), // Vista de ponentes
                ExhibitorsLayout(companies: companies), // Vista de expositores
              ],
            ),
            // Barra de navegación inferior
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(Icons.home, color: Colors.white),
                    label: 'Inicio',
                    backgroundColor: Colors.black),
                BottomNavigationBarItem(
                    icon: Icon(Icons.car_crash, color: Colors.white),
                    label: 'Proyectos',
                    backgroundColor: Colors.black),
                BottomNavigationBarItem(
                    icon: Icon(Icons.map, color: Colors.white),
                    label: 'Mapa',
                    backgroundColor: Colors.black),
                BottomNavigationBarItem(
                    icon: Icon(Icons.flag, color: Colors.white),
                    label: 'Ponentes',
                    backgroundColor: Colors.black),
                BottomNavigationBarItem(
                    icon: Icon(Icons.add_home_work_sharp, color: Colors.white),
                    label: 'Expositores',
                    backgroundColor: Colors.black),
              ],
              currentIndex: _selectedIndex, // Índice actual seleccionado
              onTap: _onItemTapped, // Función al tocar un ítem
              selectedItemColor: Colors.blueAccent, // Color del ítem seleccionado
              unselectedItemColor: Colors.black, // Color de ítems no seleccionados
            ),
          );
        }
      },
    );
  }

// Widget que construye la pantalla de inicio
  Widget _homeScreen() {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            // Sección del video
            Row(
              children: [
                Expanded(
                    child: Ytvideo(
                      videoUrl: 'https://youtu.be/O5OcIboxnkw', // URL del video
                      hide_control: true, // Oculta los controles
                      is_muted: true, // Video silenciado
                    )
                )
              ],
            ),

            // Sección de proyectos con título clickeable
            TitleSection(
              title: 'DESCUBRE TODOS LOS PROYECTOS',
              subtitle: 'PROYECTOS',
              onTitleTap: () {}, // Acción al tocar el título (vacía)
              onSubtitleTap: () { // Acción al tocar el subtítulo
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProjectsLayout(
                        projects: projectos,
                        proj_mng: proj_mng,
                        monlauTech_mng: mont_mng,
                        monlauTechPrj: monlautech,
                      ),
                    )
                );
              },
            ),

            // Línea decorativa
            Row(children: [
              CustomPaint(size: const Size(100, 10), painter: LinePainter())
            ]),

            // Lista horizontal de proyectos
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal, // Scroll horizontal
                itemCount: projectos.length, // Cantidad de proyectos
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () { // Al tocar un proyecto
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProjectIndividualLayout(
                              project: projectos[index]), // Pasa el proyecto seleccionado
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 4, // Elevación de la tarjeta
                        child: Container(
                          width: 250,
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Título del proyecto
                              Text(
                                projectos[index].Titulo ?? "Título por defecto",
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              // Nombre del autor
                              Text(
                                '${projectos[index].Autor[0].name}${' '}${projectos[index].Autor[0].surname_1}',
                                style: const TextStyle(fontSize: 14),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              // Nivel de estudios
                              Text(
                                projectos[index].NivelEstudios,
                                style: const TextStyle(fontSize: 14),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Otra línea decorativa
            Row(children: [
              CustomPaint(size: const Size(100, 10), painter: LinePainter())
            ]),

            // Sección de ponentes con título clickeable
            TitleSection(
              title: 'DESCUBRE LOS PONENTES',
              subtitle: 'PONENTES',
              onTitleTap: () {}, // Acción al tocar el título (vacía)
              onSubtitleTap: () { // Acción al tocar el subtítulo
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SpeakersLayout(ponencias: meets)
                  ),
                );
              },
            ),

            // Lista vertical de ponentes
            Column(
              children: List.generate(meets.length, (index) {
                return InkWell(
                  onTap: () { // Al tocar un ponente
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return SpeakersPopUpCArd(
                              speakers: meets[index].speakers,
                              meets: meets[index]
                          );
                        }
                    );
                  },
                  child: CustomCard(
                      title: meets[index].name ?? "Título por defecto", // Nombre del ponente
                      time: meets[index].initTime ?? "00:00", // Hora de inicio
                      imageUrl: "", // URL de imagen (vacía)
                      description: meets[index].description ?? "Sin descripción" // Descripción
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // Widget de pantalla placeholder (no utilizado actualmente)
  Widget _placeholderScreen(String title) {
    return Center(child: Text(title, style: const TextStyle(fontSize: 24)));
  }
}