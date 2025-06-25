class User {
  String? id;
  String? name;
  String? email;
  String? birthday;
  int? coin;
  String? password;
  String? role;

  User.fromJson(Map<String, dynamic> json) {
    id = json["_id"];
    name = json["name"];
    email = json["email"];
    birthday = json["birthday"];
    password = json["password"];
    role = json["role"];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    name = data["name"];
    email = data["email"];
    birthday = data["birthday"];
    password = data["password"];
    return data;
  }
}
