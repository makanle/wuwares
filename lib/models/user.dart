enum UserRole { admin, user }

class User {
  final String username;
  final String email;
  final UserRole role;

  User({
    required this.username,
    required this.email,
    required this.role,
  });
}
