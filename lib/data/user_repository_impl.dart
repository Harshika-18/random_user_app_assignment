import 'package:random_user_app/domain/user_repository.dart'; // Updated
import 'package:random_user_app/domain/user.dart'; // Updated
import 'api_service.dart'; // Relative within data

class UserRepositoryImpl implements UserRepository {
  final ApiService apiService;

  UserRepositoryImpl(this.apiService);

  @override
  Future<List<User>> fetchUsers() async {
    return await apiService.fetchUsers();
  }
}
