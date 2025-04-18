import 'package:app_maquinista/custom_widgets/line_painter.dart';
import 'package:app_maquinista/custom_widgets/pop_up_speaker_card.dart';
import 'package:app_maquinista/custom_widgets/speakers_card.dart';
import 'package:app_maquinista/model/meetings.dart';
import 'package:app_maquinista/model/speakers.dart';
import 'package:flutter/material.dart';

import 'custom_widgets/custom_card.dart';

class SpeakersLayout extends StatefulWidget {
  SpeakersLayout({super.key, required this.ponencias});

  List<Meetings> ponencias;

  @override
  _SpeakersLayout createState() => _SpeakersLayout();
}

final List<Map<String, String>> pruebasDinamicas = [
  {
    "title": "Prueba 1",
    "equipo": "Equipo 1",
    "time": "10:00",
  },
  {
    "title": "Prueba 2",
    "equipo": "Equipo 2",
    "time": "10:00",
  },
  {
    "title": "Prueba 3",
    "equipo": "Equipo 3",
    "time": "10:00",
  },
];

class _SpeakersLayout extends State<SpeakersLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 100,
                height: 110,
                child: Image.asset('assets/img/logomonlau.png'),
              ),
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
                              "Ponencias",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                          ),
                          const SizedBox(width: 110),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  CustomPaint(
                    size: Size(100, 10),
                    painter: LinePainter(),
                  )
                ],
              ),
              Expanded(
                  child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.zero,
                itemCount: widget.ponencias.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return SpeakersPopUpCArd(
                                speakers: widget.ponencias[index].speakers[0]);
                          });
                    },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 4,
                          child: Container(
                            width: 250,
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.ponencias[index].name ?? "Título por defecto",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  widget.ponencias[index].initTime ?? "00:00",
                                  style: const TextStyle(fontSize: 14),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                /*
                                Text(
                                  widget.ponencias[index].speakers[0].name.toString() ?? "00:00",
                                  style: const TextStyle(fontSize: 14),
                                  textAlign: TextAlign.center,
                                ),
                                 */
                              ],
                            ),
                          ),
                        ),
                      )
                  );
                },
              )),
              Padding(
                padding: const EdgeInsets.only(left: 13.0, top: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 500,
                            child: Text(
                              "Pruebas Dinamicas",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                          ),
                          const SizedBox(width: 110),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  CustomPaint(
                    size: Size(100, 10),
                    painter: LinePainter(),
                  )
                ],
              ),
              Expanded(
                  child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.zero,
                itemCount: pruebasDinamicas.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {

                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 4,
                        child: Container(
                          width: 250,
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                pruebasDinamicas[index]["title"] ?? "Título por defecto",
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                pruebasDinamicas[index]["equipo"] ?? "Sin equipo",
                                style: const TextStyle(fontSize: 14),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                pruebasDinamicas[index]["time"] ?? "00:00",
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
              ))
            ],
          ),
        ),
      ),
    );
  }
}
