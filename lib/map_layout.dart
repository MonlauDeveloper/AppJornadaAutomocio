import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'custom_widgets/carrousel_img.dart';
import 'custom_widgets/line_painter.dart';

class MapLayout extends StatefulWidget {
  MapLayout({super.key});

  @override
  _MapLayout createState() => _MapLayout();
}

class _MapLayout extends State<MapLayout> {

  final List<String> imgEvent = [
    'assets/img/monlautech1.jpg','assets/img/monlautech2.jpg','assets/img/monlautech3.jpg',
    'assets/img/monlautech4.jpg','assets/img/monlautech5.jpg','assets/img/monlautech6.jpg'
  ];
  final List<String> imgMaps =  [
    "assets/img/Plano.png",
    "assets/img/PlanoParking.png",
  ];

  Future<void> _openGoogleMaps() async {
    const String googleMapsUrl = "https://www.google.com/maps/place/Nürburgreen+Indoor+-+Karting+Electric/@41.6212348,2.3090303,17z/data=!3m1!4b1!4m6!3m5!1s0x12a4c92990070199:0xba70db840d176db2!8m2!3d41.6212348!4d2.3116052!16s%2Fg%2F11s_zq9ksf?entry=ttu&g_ep=EgoyMDI1MDQyMy4wIKXMDSoJLDEwMjExNDU1SAFQAw%3D%3D";
    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'No se pudo abrir Google Maps';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Center(
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: SizedBox(
            width: 100,
            height: 90,
            child: Image.asset('assets/img/logomonlau.png'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12.0, bottom: 12.0),
          child: Row(
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
              ])
            ],
          ),
        ),
        Row(
          children: [
            Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: CustomPaint(
                  size: Size(100, 10),
                  painter: LinePainter(),
                )),
          ],
        ),
        SizedBox(
          width: 500,
          height: 270,
          child:
              Row(
                children: [Expanded(child: CarrouselImg(imgList: imgMaps))],
              )
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(top: 12.0, bottom: 12.0, left: 12.0),
            child: Row(children: [
              SizedBox(
                  width: 200,
                  child: Text(
                    "Imagenes del Evento",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 17),
                  )),
            ],
            ),
          ),
          Padding(padding: const EdgeInsets.only(bottom: 12.0),
              child: CustomPaint(
                size: Size(100, 10),
                painter: LinePainter(),
              )
          ),
          Row(
            children: [Expanded(child: CarrouselImg(imgList: imgEvent))],
          )
        ])
      ]),
    )));
  }
}

