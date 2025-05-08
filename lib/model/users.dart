import 'package:app_maquinista/model/roles.dart';
//lo mismo que la classe companies pero para las/los usuarios generamente los exponentes
class User {
  String userName;
  String password;
  Role role;
  User(
      this.userName,
      this.password,
      this.role
      );
}