import 'package:equatable/equatable.dart';

enum UserRole { approver, admin, viewer }

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String token;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.token,
  });

  @override
  List<Object> get props => [id, name, email, role, token];
}
