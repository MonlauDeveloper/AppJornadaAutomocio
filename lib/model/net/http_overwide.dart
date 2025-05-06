import 'dart:io';

//classe para hace que la aplicación pueda gestionar peteciones http
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;// especificamos el certificado
  }
}