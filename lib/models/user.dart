enum UserRole { admin, user }

class User {
  final String username;
  final UserRole role;

  User({
    required this.username,
    required this.role,
  });
}
