import 'package:app_maquinista/main.dart';
import 'package:app_maquinista/model/net/Netload.dart';
import 'package:app_maquinista/model/net/net_filter_projects.dart';
import 'package:app_maquinista/model/net/net_projects.dart';
import 'package:flutter/material.dart';
import 'package:app_maquinista/model/projectos.dart';
import 'package:app_maquinista/model/dinamicTest.dart';
import 'custom_widgets/project_cards.dart';
import 'custom_widgets/line_painter.dart';
import 'model/net/net_projects.dart';
import 'project_individual_layout.dart';
const Map<String,int>spe_idspe ={
  "GS Automoción":4 ,
  "GM Electromecánica":1,
  "GM Carrocería" : 3,
  "GM Motocicletas" : 2
};
class ProjectsLayout extends StatefulWidget {
  ProjectsLayout({
    super.key,
    required this.projects,
    required this.proj_mng,
    required this.monlauTech_mng,
    required this.monlauTechPrj,
  });

  Netload proj_mng;
  NetProjects proj_all = NetProjects(0,"","");
  NetFilterProjects filter_mng_students = NetFilterProjects(7);
  NetFilterProjects filter_mng_tittle = NetFilterProjects(7);
  NetFilterProjects filter_mng_course = NetFilterProjects(7);
  List<Proyecto> projects;

  Netload monlauTech_mng;
  final List<DinamicTest> monlauTechPrj;
  int current = 1;
  final ScrollController scController = ScrollController();

  @override
  _ProjectsLayout createState() => _ProjectsLayout();
}

class _ProjectsLayout extends State<ProjectsLayout>
    with SingleTickerProviderStateMixin {
  String _filterSelectOption = "Todos";
  final List<String> _filter = [
    "Todos",
    "GS Automoción",
    "GM Electromecánica",
    "GM Carrocería",
    "GM Motocicletas",
    "Num. Tribunal"
  ];
  List<Proyecto> filteredProjects = [];

  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  
  List<Proyecto> filtrar (List<Proyecto> prjs){
   
    if (_filterSelectOption != "Todos"){
      return prjs.where((test) => test.NivelEstudios == _filterSelectOption).toList();
    } else if (_filterSelectOption != "Num. Tribunal") {
      return prjs.where((test) => test.Box == _filterSelectOption).toList();
    } else{
      return prjs;
    }
  }
  @override
  void initState() {
    super.initState();
    widget.filter_mng_tittle.where = "title";
    widget.filter_mng_students.where = "student";
    widget.filter_mng_course.where ="idSpecialization";
    widget.proj_all = proj_mng;

    _tabController = TabController(length: 2, vsync: this);
    filteredProjects = widget.projects; // Inicializar con todos los proyectos
    _searchController.addListener(()=>_filterProjectos(widget.current));
   
    widget.scController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();

    widget.scController.removeListener(_onScroll);
    widget.scController.dispose();
    super.dispose();
  }

  // Filtrar proyectos basados en el texto de búsqueda y el filtro seleccionado
  Future<void> _filterProjectos(int page) async {
    final query = _searchController.text.toLowerCase();
    if (query.isNotEmpty && _filterSelectOption == "Todos"){
      List<Proyecto> projs = [];
      widget.current = 1;
       
      widget.filter_mng_tittle.value = query;
      widget.filter_mng_students.value = query;
      widget.filter_mng_tittle.where = "title";
      widget.filter_mng_students.where = "student";
      widget.filter_mng_course.where ="idSpecialization";
      projs.addAll(await widget.filter_mng_tittle.get_page(page));
      projs.addAll(await widget.filter_mng_students.get_page(page));
      
      setState(() {
          widget.projects = projs;
      });
    }else if(query.isEmpty && _filterSelectOption != "Todos"){
      
      widget.filter_mng_course.where ="idSpecialization";
      widget.filter_mng_course.value = spe_idspe[_filterSelectOption].toString();
      List<Proyecto> a = await widget.filter_mng_course.get_page(page);
      setState(() {
        widget.projects = a;
      });

    }else if(query.isEmpty && _filterSelectOption == "Todos"){
      List<Proyecto> a = await widget.proj_mng.get_page(widget.current) as List<Proyecto>;
      setState(() {
          widget.projects = a;
      });
    }else if (query.isNotEmpty && _filterSelectOption != "Todos"){
        List<Proyecto> projs = [];
        widget.current = 1;
      if (_filterSelectOption == "Num. Tribunal"){
        widget.filter_mng_course.where ="numTribunal";
        widget.filter_mng_course.value = query;
        
        projs.addAll(await widget.filter_mng_course.get_page(page));
        projs = projs.where((element) => element.Box == query).toList();
        setState(() {
            widget.projects = projs;
        });
      }else{
      
        
        widget.filter_mng_tittle.value = query;
        widget.filter_mng_students.value = query;
        widget.filter_mng_tittle.where = "title";
        widget.filter_mng_students.where = "student";
        widget.filter_mng_course.where ="idSpecialization";
        projs.addAll(await widget.filter_mng_tittle.get_page(page));
        projs.addAll(await widget.filter_mng_students.get_page(page));
        
        setState(() {
            widget.projects = filtrar(projs);
        });
      }
      
    }
  }

  // Cargar más proyectos cuando se llega al final de la lista
  void _onScroll() {
    
    /*widget.scController.position.pixels != 0 && widget.scController.position.atEdge */
    if(widget.scController.offset >= widget.scController.position.maxScrollExtent)
    {
      _loadMoreProjects();
    }
    
  }

  Future<void> _loadMoreProjects() async {
    if (widget.current <= widget.proj_mng.available_pages) {
      List<Proyecto> pre = widget.projects;

      await _filterProjectos(widget.current);
      setState(()  {
      
      pre.addAll(widget.projects);
      widget.projects = pre;
      widget.current ++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Sección superior con los logos de la aplicación
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo principal de Monlau
                    SizedBox(
                      width: 100,
                      height: 90,
                      child: Image.asset('assets/img/logomonlau.png'),
                    ),
                    // Logo secundario
                    SizedBox(
                      width: 100,
                      height: 90,
                      child: Image.asset('assets/img/logo2.jpg'),
                    )
                  ],
                ),
              ),

              // Fila con las pestañas de navegación y el filtro desplegable
              Padding(
                padding: const EdgeInsets.only(left: 13.0),
                child: Row(
                  children: [
                    // Contenedor expandido para las pestañas
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.transparent)),
                            ),
                            // Barra de pestañas personalizada
                            child: TabBar(
                              controller: _tabController, // Controlador para gestionar las pestañas
                              indicator: const BoxDecoration(), // Sin indicador visual
                              dividerColor: Colors.transparent, // Sin divisor
                              indicatorColor: Colors.blue, // Color del indicador activo
                              labelColor: Colors.blue, // Color del texto activo
                              unselectedLabelColor: Colors.black, // Color del texto inactivo
                              labelPadding: EdgeInsets.symmetric(
                                  horizontal: MediaQuery.of(context).size.width * 0.02,
                                  vertical: 0), // Padding adaptable
                              isScrollable: true, // Permite scroll si hay muchas pestañas
                              tabAlignment: TabAlignment.start, // Alineación a la izquierda
                              tabs: const [
                                Tab(text: "Proyectos"), // Primera pestaña
                                Tab(text: "MonlauTech"), // Segunda pestaña
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Selector desplegable para filtrado
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: DropdownButton<String>(
                        value: _filter.contains(_filterSelectOption)
                            ? _filterSelectOption
                            : null, // Valor seleccionado
                        hint: const Text("Selecciona una opción"), // Texto por defecto
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.black), // Icono
                        dropdownColor: Colors.white, // Color del menú desplegable
                        style: const TextStyle(color: Colors.black), // Estilo del texto
                        underline: Container(), // Elimina la línea inferior
                        onChanged: (String? newValue) { // Callback al seleccionar
                          setState(() {
                            _filterSelectOption = newValue!;
                          });
                          _filterProjectos(widget.current); // Filtra los proyectos
                        },
                        items: _filter.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: const TextStyle(color: Colors.black)),
                          );
                        }).toList(), // Opciones del menú
                      ),
                    )
                  ],
                ),
              ),

              // Línea decorativa bajo los filtros
              Row(
                children: [
                  CustomPaint(
                    size: Size(100, 10),
                    painter: LinePainter(), // Widget personalizado para la línea
                  ),
                ],
              ),

              // Campo de búsqueda de proyectos
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: _searchController, // Controlador para el texto de búsqueda
                  decoration: InputDecoration(
                    hintText: 'Buscar proyecto', // Placeholder
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10), // Bordes redondeados
                    ),
                  ),
                ),
              ),

              // Contenedor principal para el contenido de las pestañas
              Expanded(
                child: TabBarView(
                  controller: _tabController, // Mismo controlador que el TabBar
                  children: [
                    _projects(), // Vista de proyectos
                    _monlauTech() // Vista de MonlauTech
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// Widget que construye la lista de proyectos
  Widget _projects() {
    return ListView.builder(
      controller: widget.scController, // Controlador de scroll
      padding: EdgeInsets.zero, // Sin padding
      itemCount: widget.projects.length, // Número de proyectos
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () { // Al hacer tap en un proyecto
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProjectIndividualLayout(
                  project: widget.projects[index], // Pasa el proyecto seleccionado
                ),
              ),
            );
          },
          child: ProjectCards(
            projecto: widget.projects[index], // Tarjeta del proyecto
          ),
        );
      },
    );
  }

// Widget que construye la lista de proyectos MonlauTech
  Widget _monlauTech() {
    return ListView.builder(
      shrinkWrap: true, // Ajusta el tamaño al contenido
      padding: EdgeInsets.zero, // Sin padding
      itemCount: widget.monlauTechPrj.length, // Número de proyectos MonlauTech
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () { // Al hacer tap en un proyecto
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProjectIndividualLayout(
                  project: widget.monlauTechPrj[index], // Pasa el proyecto seleccionado
                ),
              ),
            );
          },
          child: ProjectCards(
            projecto: widget.monlauTechPrj[index], // Tarjeta del proyecto
          ),
        );
      },
    );
  }
}