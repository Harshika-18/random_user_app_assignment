import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_user_app/presentation/user_state.dart';
import '../domain/user_repository.dart';

class UserNotifier extends StateNotifier<UserState> {
  final UserRepository repository;

  UserNotifier(this.repository) : super(const UserState());

  Future<void> fetchUsers() async {
    state = state.copyWith(isLoading: true);
    try {
      final users = await repository.fetchUsers();
      state = state.copyWith(users: users, isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> fetchUsersByCountry(String country) async {
    state = state.copyWith(isLoading: true);
    try {
      final users = await repository.fetchUsers();
      final filteredUsers =
          country.isEmpty || country == 'All'
              ? users ?? []
              : (users ?? [])
                  .where(
                    (user) =>
                        user.country.toLowerCase() == country.toLowerCase(),
                  )
                  .toList();
      //print(
      //  'Filtered users for $country: ${filteredUsers.length}',
      //); // Debug log
      state = state.copyWith(
        users: filteredUsers,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      //print('Error filtering by $country: $e');
    }
  }

  void toggleLike(String firstName) {
    final updatedUsers =
        state.users.map((user) {
          if (user.firstName == firstName) {
            return user.copyWith(isLiked: !user.isLiked);
          }
          return user;
        }).toList();
    state = state.copyWith(users: updatedUsers);
  }
}
