// lib/presentation/user_state.dart
import 'package:random_user_app/domain/user.dart'; // Added

class UserState {
  final List<User> users;
  final bool isLoading;
  final String? error;

  const UserState({this.users = const [], this.isLoading = false, this.error});

  UserState copyWith({List<User>? users, bool? isLoading, String? error}) {
    return UserState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
