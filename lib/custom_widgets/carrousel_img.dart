// Importación de paquetes necesarios
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

// Widget sin estado (Stateless) que recibe una lista de rutas de imágenes como parámetro
class CarrouselImg extends StatelessWidget {
  final List<String> imgList;

  const CarrouselImg({super.key, required this.imgList});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      // Configuración del carrusel
      options: CarouselOptions(
        height: 200.0,              // Altura del carrusel
        enlargeCenterPage: true,   // Amplía la imagen centrada
      ),
      // Genera un widget para cada imagen de la lista
      items: imgList.map((item) {
        return GestureDetector(
          // Al pulsar sobre una imagen, se abre un visor en pantalla completa
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => Dialog(
                insetPadding: EdgeInsets.zero, // Elimina el espacio por defecto alrededor del diálogo
                backgroundColor: Colors.transparent, // Fondo transparente para el diálogo
                child: Container(
                  // Tamaño del visor: 98% de ancho, 90% de alto
                  width: MediaQuery.of(context).size.width * 0.98,
                  height: MediaQuery.of(context).size.height * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.white, // Fondo blanco del visor
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    children: [
                      // Imagen con zoom y desplazamiento habilitados
                      InteractiveViewer(
                        panEnabled: true,   // Permite mover la imagen
                        minScale: 0.5,      // Escala mínima
                        maxScale: 4.0,      // Escala máxima
                        child: Center(
                          child: Image.asset(
                            item,            // Ruta de la imagen
                            fit: BoxFit.contain, // Ajusta la imagen sin recortarla
                          ),
                        ),
                      ),
                      // Botón de cierre en la esquina superior derecha
                      Positioned(
                        top: 10,
                        right: 10,
                        child: IconButton(
                          icon: Icon(Icons.close, color: Colors.black),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          // Imagen mostrada en el carrusel
          child: ClipRRect(
            child: Image.asset(
              item,
              fit: BoxFit.cover,      // Cubre todo el contenedor (recorta si es necesario)
              width: double.infinity, // Ocupa todo el ancho disponible
            ),
          ),
        );
      }).toList(), // Convierte los widgets generados en una lista
    );
  }
}
