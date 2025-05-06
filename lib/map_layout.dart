import 'package:flutter/material.dart';
import 'custom_widgets/carrousel_img.dart';
import 'custom_widgets/line_painter.dart';

class MapLayout extends StatefulWidget {
  MapLayout({super.key});

  @override
  _MapLayout createState() => _MapLayout();
}

class _MapLayout extends State<MapLayout> {
  // Lista de imágenes del evento para mostrar en el carrusel
  final List<String> imgEvent = [
    'assets/img/monlautech1.jpg',
    'assets/img/monlautech2.jpg',
    'assets/img/monlautech3.jpg',
    'assets/img/monlautech4.jpg',
    'assets/img/monlautech5.jpg',
    'assets/img/monlautech6.jpg'
  ];

  // Lista de mapas para mostrar en el carrusel
  final List<String> imgMaps = [
    "assets/img/Plano.png", // Mapa principal
    "assets/img/PlanoParking.png", // Mapa de parking
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Encabezado con el logo
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 280,
                          height: 95,
                          child: Image.asset('assets/img/logo_monlau_sf.png'), // Logo principal
                        ),
                      ],
                    ),
                  ),

                  // Título de la sección del mapa
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, bottom: 12.0),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 150,
                              child: Text(
                                "Mapa de la Zona",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 17),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),

                  // Línea decorativa bajo el título del mapa
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: CustomPaint(
                          size: Size(100, 10),
                          painter: LinePainter(), // Widget de línea personalizada
                        ),
                      ),
                    ],
                  ),

                  // Sección del carrusel de mapas
                  SizedBox(
                      width: 500,
                      height: 270,
                      child: Row(
                        children: [
                          Expanded(
                              child: CarrouselImg(imgList: imgMaps) // Carrusel de mapas
                          )
                        ],
                      )
                  ),

                  // Sección de imágenes del evento
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Título de la sección
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0, bottom: 12.0, left: 12.0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 200,
                                child: Text(
                                  "Imagenes del Evento",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 17),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Línea decorativa bajo el título de imágenes
                        Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: CustomPaint(
                              size: Size(100, 10),
                              painter: LinePainter(),
                            )
                        ),

                        // Carrusel de imágenes del evento
                        Row(
                          children: [
                            Expanded(
                                child: CarrouselImg(imgList: imgEvent) // Carrusel de imágenes
                            )
                          ],
                        )
                      ]
                  )
                ],
              ),
            )
        )
    );
  }
}