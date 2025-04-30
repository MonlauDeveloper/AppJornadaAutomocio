import 'package:flutter/material.dart';
import 'package:app_maquinista/custom_widgets/line_painter.dart';
import 'package:app_maquinista/custom_widgets/pop_up_speaker_card.dart';
import 'package:app_maquinista/custom_widgets/speakers_card.dart';
import 'package:app_maquinista/model/meetings.dart';
import 'package:app_maquinista/model/speakers.dart';
import 'package:app_maquinista/custom_widgets/custom_card.dart';

class SpeakersLayout extends StatefulWidget {
  SpeakersLayout({super.key, required this.ponencias});

  final List<Meetings> ponencias;

  @override
  _SpeakersLayout createState() => _SpeakersLayout();
}

final List<Map<String, String>> pruebasDinamicas = [
  {"title": "Pruebas de aceleración, Slalom y frenada", "site": "Circuito MonlauTech", "time": "09:20"},
  {"title": "Pruebas de resistencia", "site": "Circuito MonlauTech", "time": "11:00"},
];

class _SpeakersLayout extends State<SpeakersLayout> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
                              border: Border(bottom: BorderSide(color: Colors.transparent)),
                            ),
                            child: TabBar(
                              controller: _tabController,
                              indicator: const BoxDecoration(),
                              dividerColor: Colors.transparent,
                              indicatorColor: Colors.blue,
                              labelColor: Colors.blue,
                              unselectedLabelColor: Colors.grey,
                              labelPadding: EdgeInsets.symmetric(
                                  horizontal: MediaQuery.of(context).size.width * 0.02,
                                  vertical: 0),
                              isScrollable: true,
                              tabAlignment: TabAlignment.start,
                              tabs: const [
                                Tab(text: "Ponencias"),
                                Tab(text: "Pruebas Dinámicas"),
                              ],
                            ),
                          ),
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
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [_ponencias(), pruebas_dinamicas()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ponencias() {
    return ListView.builder(
      //scrollDirection: Axis.horizontal,
      padding: EdgeInsets.zero,
      itemCount: widget.ponencias.length,
      itemBuilder: (context, index) {
        final ponencia = widget.ponencias[index];
        return InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return SpeakersPopUpCArd(
                  speakers: ponencia.speakers[0], meets: ponencia);
              },
            );
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
                      ponencia.name ?? "Título por defecto",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      ponencia.initTime ?? "00:00",
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
    );
  }

  Widget pruebas_dinamicas() {
    return ListView.builder(
      //scrollDirection: Axis.horizontal,
      padding: EdgeInsets.zero,
      itemCount: pruebasDinamicas.length,
      itemBuilder: (context, index) {
        final prueba = pruebasDinamicas[index];
        return Padding(
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
                    prueba["title"] ?? "Título por defecto",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    prueba["site"] ?? "Sin equipo",
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    prueba["time"] ?? "00:00",
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}