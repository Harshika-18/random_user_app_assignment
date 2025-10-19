// lib/domain/user_repository.dart
import 'user.dart';

abstract class UserRepository {
  Future<List<User>> fetchUsers();
}
