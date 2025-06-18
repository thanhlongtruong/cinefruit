class User {
  final String name;
  final String email;
  final String password;

  static User? _instance;

  User._internal({
    required this.name,
    required this.email,
    required this.password,
  });

  // singleton pattern trong Dart để đảm bảo chỉ có một đối tượng User duy nhất tồn tại trong ứng dụng
  factory User({
    required String name,
    required String email,
    required String password,
  }) {
    _instance ??= User._internal(name: name, email: email, password: password);
    return _instance!;
  }

  static User? get instance => _instance;
}
