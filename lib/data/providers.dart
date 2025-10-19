import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_user_app/presentation/user_state.dart';
import 'user_repository_impl.dart';
import 'api_service.dart';
import 'user_notifier.dart';
import '../domain/user_repository.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return UserRepositoryImpl(apiService);
});

final userNotifierProvider = StateNotifierProvider<UserNotifier, UserState>((
  ref,
) {
  final repository = ref.watch(userRepositoryProvider);
  return UserNotifier(repository);
});

final countryFilterProvider = Provider<List<String>>((ref) {
  final userState = ref.watch(userNotifierProvider);
  final countries =
      userState.users
          .map((user) => user.country.toLowerCase())
          .toSet()
          .toList(); // Normalize case
  countries.sort();
  print('Countries list: $countries'); // Debug log
  return ['All', ...countries];
});
