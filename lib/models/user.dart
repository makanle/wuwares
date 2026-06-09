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
  factory User.fromJson(Map<String, dynamic> json){
    UserRole userRole = UserRole.user;
    if(json['role'].toString() == 'admin') userRole = UserRole.admin;
    return User(
    username: json['username'] as String,
    email: json['email'] as String,
    role: userRole,
    );
  }
}
