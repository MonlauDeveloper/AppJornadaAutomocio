import 'package:app_maquinista/model/roles.dart';
import 'package:app_maquinista/model/users.dart';
import 'package:flutter/cupertino.dart';
//clsse de las companias en esto se tranforma el json de la api
class Companies{
  String name;
  User agent;
  String stand;
  String web;
  String img_url;

  Companies(
      this.name,
      this.agent,
      this.stand,
      this.web,
      this.img_url
      );
      //constructor tipo factory para crear una nstacia a partir de un json
  factory Companies.fromJson (Map<String, dynamic> com){
    String server = "https://jornadaautomocion.alumnes-monlau.com/storage/photos/";
    if (com["logo_url"].toString().contains("http")){
      server ="";
    }
    return Companies(com["companyName"]??"", User(com["asistenteNombre"]??"","",Role.COMPANIE), "",com["companyWeb"]??"",server+com["logo_url"]);
  }
}