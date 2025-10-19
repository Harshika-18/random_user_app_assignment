import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_user_app/data/providers.dart';
import 'profile_detail_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _selectedCountry = 'All';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userNotifierProvider.notifier).fetchUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userNotifierProvider);
    final countries = ref.watch(countryFilterProvider);

    // Ensure _selectedCountry is valid
    if (!countries.contains(_selectedCountry)) {
      _selectedCountry = countries.isNotEmpty ? countries.first : 'All';
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Home', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          DropdownButton<String>(
            value:
                _selectedCountry.isNotEmpty
                    ? _selectedCountry
                    : null, // Use null if empty
            dropdownColor: Colors.white,
            style: const TextStyle(color: Colors.black),
            iconEnabledColor: Colors.black,
            hint: const Text(
              'Select Country',
              style: TextStyle(color: Colors.black),
            ), // Fallback
            items:
                countries.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedCountry = newValue;
                });
                ref
                    .read(userNotifierProvider.notifier)
                    .fetchUsersByCountry(newValue)
                    .catchError((e) {
                      print('Dropdown error: $e');
                    });
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: () {
              ref.read(userNotifierProvider.notifier).fetchUsers();
            },
          ),
        ],
      ),
      body:
          userState.isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.black),
              )
              : userState.error != null
              ? Center(
                child: Text(
                  'Error: ${userState.error}',
                  style: const TextStyle(color: Colors.black),
                ),
              )
              : userState.users.isEmpty
              ? const Center(
                child: Text(
                  'No users found',
                  style: const TextStyle(color: Colors.black),
                ),
              )
              : RefreshIndicator(
                color: Colors.black,
                onRefresh: () async {
                  await ref.read(userNotifierProvider.notifier).fetchUsers();
                },
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.75,
                        ),
                    itemCount: userState.users.length,
                    itemBuilder: (context, index) {
                      final user = userState.users[index];
                      return GestureDetector(
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProfileDetailScreen(user: user),
                              ),
                            ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            children: [
                              Hero(
                                tag: 'user-image-${user.firstName}',
                                child: Image.network(
                                  user.imageUrl,
                                  fit: BoxFit.cover,
                                  height: double.infinity,
                                  width: double.infinity,
                                  errorBuilder:
                                      (_, __, ___) =>
                                          Container(color: Colors.grey[900]),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withAlpha(153),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 8,
                                bottom: 8,
                                right: 8,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user.firstName,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          user.city,
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        ref
                                            .read(userNotifierProvider.notifier)
                                            .toggleLike(user.firstName);
                                      },
                                      child: AnimatedScale(
                                        scale: user.isLiked ? 1.2 : 1.0,
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
                                        child: Icon(
                                          user.isLiked
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color:
                                              user.isLiked
                                                  ? Colors.red
                                                  : Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
    );
  }
}
