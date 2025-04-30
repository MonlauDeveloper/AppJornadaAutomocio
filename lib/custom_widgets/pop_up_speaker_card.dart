import 'package:app_maquinista/model/meetings.dart';
import 'package:app_maquinista/model/speakers.dart';
import 'package:flutter/material.dart';

class SpeakersPopUpCArd extends StatelessWidget {
  final List<Speakers> speakers;
  final Meetings meets;

  const SpeakersPopUpCArd({
    super.key,
    required this.speakers,
    required this.meets
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 10,
      backgroundColor: Colors.white,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
          maxHeight: MediaQuery.of(context).size.height * 0.7, // Límite máximo
        ),
        child: SingleChildScrollView( // Para contenido desplazable si excede el tamaño
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Crucial para ajuste automático
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: speakers.length,
                        itemBuilder: (context, index) {
                          return Text(
                            speakers[index].get_all_name(),
                            textAlign: TextAlign.center,
                            maxLines: 5,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          );
                        }
                    ),
                    /*
                    Text(
                      '${speakers.name} ${speakers.surname1}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),*/
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        speakers[0].biography,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14),
                        maxLines: 4, // Máximo de líneas antes de overflow
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Hora: ${meets.initTime}',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(150, 45),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cerrar"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}