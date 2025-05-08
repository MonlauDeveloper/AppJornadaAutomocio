import 'package:app_maquinista/model/companies.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'custom_widgets/line_painter.dart';

class ExhibitorsLayout extends StatefulWidget {
  ExhibitorsLayout({super.key, required this.companies});

  @override
  _ExhibitorsLayout createState() => _ExhibitorsLayout();

  List<Companies> companies; // Lista de empresas expositoras recibida como parámetro
}

class _ExhibitorsLayout extends State<ExhibitorsLayout> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Encabezado con logo
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

                  // Título de la sección
                  Padding(
                    padding: const EdgeInsets.only(left: 13.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 150,
                                child: Text(
                                  "Expositores",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 110),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Línea decorativa
                  Row(
                    children: [
                      CustomPaint(
                        size: Size(100, 10),
                        painter: LinePainter(),
                      )
                    ],
                  ),

                  // Lista de expositores (parte principal)
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: widget.companies.length, // Usa la lista de empresas del widget padre
                            itemBuilder: (context, index) {
                              return InkWell(
                                  onTap: () {
                                    // Abre la página web de la empresa al pulsar
                                    launchUrl(Uri.parse(widget.companies[index].web));
                                  },
                                  child: Card(
                                    margin: const EdgeInsets.all(12),
                                    elevation: 8, // Sombra
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16), // Bordes redondeados
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        // Imagen de la empresa
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Image.network(
                                            widget.companies[index].img_url,
                                            height: 150,
                                            width: 150,
                                            fit: BoxFit.cover,
                                          ),
                                        ),

                                        // Espaciador
                                        SizedBox(
                                          height: 10,
                                          width: MediaQuery.of(context).size.width * 0.78,
                                        ),

                                        // Nombre de la empresa
                                        Text(
                                          widget.companies[index].name,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                              );
                            }
                        )
                    ),
                  ),
                ],
              ),
            )
        )
    );
  }
}