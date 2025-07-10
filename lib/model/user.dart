class User {
  String? idUser;
  String? name;
  String? email;
  String? birthday;
  String? password;
  String? role;

  User.fromJson(Map<String, dynamic> json) {
    idUser = json["_id"];
    name = json["name"];
    email = json["email"];
    birthday = json["birthday"];
    role = json["role"];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    name = data["name"];
    password = data["password"];
    return data;
  }
}
