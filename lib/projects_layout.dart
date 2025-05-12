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

//relacionamos el nombre de la especialidad con su id esto nos facilita 
//el filtrar los proyectos por curso

const Map<String,int>spe_idspe ={
  "GS Automoción":4 ,
  "GM Electromecánica":1,
  "GM Carrocería" : 3,
  "GM Motocicletas" : 2
};
//classe para representaar los proyectos en la app
class ProjectsLayout extends StatefulWidget {
  ProjectsLayout({
    super.key,
    //proyectos iniciales, son los primeros proyectos que se representan
    required this.projects,
    // objecto para cargar mas proyectos según haces scrolll
    required this.proj_mng,
    // objecto para cargar los proyectos de monlautech 
    // son lo mismo pero van en otra seción
    required this.monlauTech_mng,
    //los proyectos monlautech
    required this.monlauTechPrj,
  });

  Netload proj_mng;
  NetProjects proj_all = NetProjects(0,"","");

  // objectos para cargar los proyectos con filtros
  // nombre de estudiantes , titulo y grado
  NetFilterProjects filter_mng_students = NetFilterProjects(7);
  NetFilterProjects filter_mng_tittle = NetFilterProjects(7);
  NetFilterProjects filter_mng_course = NetFilterProjects(7);
  
  List<Proyecto> projects;

  Netload monlauTech_mng;
  final List<DinamicTest> monlauTechPrj;
  int current = 1;
  //objecto para detectar quando el usuario scrolea
  final ScrollController scController = ScrollController();

  @override
  _ProjectsLayout createState() => _ProjectsLayout();
}

class _ProjectsLayout extends State<ProjectsLayout>
    with SingleTickerProviderStateMixin {
  String _filterSelectOption = "Todos";
  //opciones de dropbox para selecionar el curso y filtrar los proyectos
  final List<String> _filter = [
    "Todos",
    "GS Automoción",
    "GM Electromecánica",
    "GM Carrocería",
    "GM Motocicletas",
    "Num. Tribunal"
  ];
  List<Proyecto> filteredProjects = [];
  //objecto para controlar los tabs entre proyecto y monlautech
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  
  //funcion para filtrar proyectos ya cargados por curso y 
  //numero del tribunal segun lo selecionado en el dropbox
  
  List<Proyecto> filtrar (List<Proyecto> prjs){
   
    if (_filterSelectOption != "Todos"){
      return prjs.where((test) => test.NivelEstudios == _filterSelectOption).toList();
    } else if (_filterSelectOption != "Num. Tribunal") {
      return prjs.where((test) => test.Box == _filterSelectOption).toList();
    } else{
      return prjs;
    }
  }
  //damos valores por defecto a la classe del layout de proyectos
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
  //destructor de la classe del layout de proyectos
  @override
  void dispose() {
    //destruimos el tab controller
    _tabController.dispose();
    //destruimos el campo de busqueda
    _searchController.dispose();
    // destruimos el scroll controller
    widget.scController.removeListener(_onScroll);
    widget.scController.dispose();
    super.dispose();
  }

  // Filtrar proyectos basados en el texto de búsqueda y el filtro seleccionado
  Future<void> _filterProjectos(int page) async {
    //rescatamos el valor del campo de texto
    final query = _searchController.text.toLowerCase();
    //si el dropbox esta establecido en todos no tenemos que aplicar un filtro adicional
    if (query.isNotEmpty && _filterSelectOption == "Todos"){
      List<Proyecto> projs = [];
      widget.current = 1;
      //establecemos los filtros
      //el valor para buscar por estudiantes y titulo sera el del camo de texto
      widget.filter_mng_tittle.value = query;
      widget.filter_mng_students.value = query;
      //indicamoss por que campos aplicar el filtro
      widget.filter_mng_tittle.where = "title";
      widget.filter_mng_students.where = "student";
      widget.filter_mng_course.where ="idSpecialization";
      //añadimos los proyectos resultantes a la lista
      projs.addAll(await widget.filter_mng_tittle.get_page(page));
      projs.addAll(await widget.filter_mng_students.get_page(page));
      //actualizamos la lista
      setState(() {
          widget.projects = projs;
      });
    //si hay otra opcion selecionada y el campo de busqueda esta vacio
    //simplemente buscamos los proyectos por el curso especificado
    }else if(query.isEmpty && _filterSelectOption != "Todos"){
      //establecemos el campo idSpecialization y 
      //con el valor del dropbox buscamos el id y el valor del filtro sera ese
      widget.filter_mng_course.where ="idSpecialization";
      widget.filter_mng_course.value = spe_idspe[_filterSelectOption].toString();
      //realizamos el mismo proceso para actualizar la lista
      List<Proyecto> a = await widget.filter_mng_course.get_page(page);
      setState(() {
        widget.projects = a;
      });
    //si el campo de busqueda y el filtro esta en todos pues rescatamos todos los proyectos
    }else if(query.isEmpty && _filterSelectOption == "Todos"){
      List<Proyecto> a = await widget.proj_mng.get_page(widget.current) as List<Proyecto>;
      setState(() {
          widget.projects = a;
      });
      //si la busqueda no esta vacia y el filtro no esta con la opcion de todos
    }else if (query.isNotEmpty && _filterSelectOption != "Todos"){
        List<Proyecto> projs = [];
        widget.current = 1;
        //coprovamos si se a selecionado la opcion de tribunal y entoces si es asi filtramos por tribunal
      if (_filterSelectOption == "Num. Tribunal"){
        widget.filter_mng_course.where ="numTribunal";
        widget.filter_mng_course.value = query;
       
        projs.addAll(await widget.filter_mng_course.get_page(page));
        projs = projs.where((element) => element.Box == query).toList();
        setState(() {
            widget.projects = projs;
        });
        // sino filtromos por cursos y por estudiante / titulo
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
      //al hacer scroll cargamos mas proyectos
      _loadMoreProjects();
    }
    
  }

  Future<void> _loadMoreProjects() async {
    if (widget.current <= widget.proj_mng.available_pages) {
      List<Proyecto> pre = widget.projects;
      setState(() {
        widget.current ++;
      });
      await _filterProjectos(widget.current);
      setState(()  {
        // eliminamos posibles duplicaciones al cargar los proyectos

        // Gente que trabaje con el codigo en un futuro esto es un parche
        //hay que mirar por que aparecen projectos duplicados a mi se me acaba
        // el convenio y no tengo tiempo  de implementar una solución correcta.
        //Todo apunta a que sea que al filtra los proyectos aya menos paginas que las totales
        //y por eso sigue entrado en el f sigue cargando otra vez la ultima pagina.
        
        final nuevos = widget.projects.where((p) => !pre.any((e) => e.Titulo + e.Resumen == p.Titulo + p.Resumen)).toList();
        pre.addAll(nuevos);
        widget.projects = pre;
        
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
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      height: 90,
                      child: Image.asset('assets/img/logomonlau.png'),
                    ),
                    SizedBox(
                      width: 100,
                      height: 90,
                      child: Image.asset('assets/img/logo2.jpg'),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 13.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.transparent)),
                            ),
                            child: TabBar(
                              controller: _tabController,
                              indicator: const BoxDecoration(),
                              dividerColor: Colors.transparent,
                              indicatorColor: Colors.blue,
                              labelColor: Colors.blue,
                              unselectedLabelColor: Colors.black,
                              labelPadding: EdgeInsets.symmetric(
                                  horizontal: MediaQuery.of(context).size.width * 0.02, vertical: 0),
                              isScrollable: true,
                              tabAlignment: TabAlignment.start,
                              tabs: const [
                                Tab(text: "Proyectos"),
                                Tab(text: "MonlauTech"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(right: 10),
                      child: DropdownButton<String>(
                        value: _filter.contains(_filterSelectOption)
                            ? _filterSelectOption
                            : null,
                        hint: const Text("Selecciona una opción"),
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                        dropdownColor: Colors.white,
                        style: const TextStyle(color: Colors.black),
                        underline: Container(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _filterSelectOption = newValue!;
                          });
                          _filterProjectos(widget.current);
                        },
                        items: _filter.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: const TextStyle(color: Colors.black)),
                          );
                        }).toList(),
                      ),
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  CustomPaint(
                    size: Size(100, 10),
                    painter: LinePainter(),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar proyecto',
                    //prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
             
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [_projects(), _monlauTech()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _projects() {
    return ListView.builder(
      controller: widget.scController,
      padding: EdgeInsets.zero,
      itemCount: widget.projects.length, // Usar la lista filtrada
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProjectIndividualLayout(
                  project: widget.projects[index], // Usar la lista filtrada
                ),
              ),
            );
          },
          child: ProjectCards(
            projecto:widget.projects[index], // Usar la lista filtrada
          ),
        );
      },
    );
  }

  Widget _monlauTech() {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: widget.monlauTechPrj.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProjectIndividualLayout(
                  project: widget.monlauTechPrj[index],
                ),
              ),
            );
          },
          child: ProjectCards(
            projecto: widget.monlauTechPrj[index],
          ),
        );
      },
    );
  }
}