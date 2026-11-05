class User {
  final String name;
  final String email;
  final String phone;

  User({
    required this.name,
    required this.email,
    this.phone = '',
  });
}
