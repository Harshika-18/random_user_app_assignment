// lib/domain/user.dart
class User {
  final String firstName;
  final String imageUrl;
  final int age;
  final String city;
  final String country;
  bool isLiked;

  User({
    required this.firstName,
    required this.imageUrl,
    required this.age,
    required this.city,
    required this.country,
    this.isLiked = false,
  });

  User copyWith({bool? isLiked}) {
    return User(
      firstName: firstName,
      imageUrl: imageUrl,
      age: age,
      city: city,
      country: country,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    try {
      return User(
        firstName: json['name']['first'] as String? ?? 'Unknown',
        imageUrl: json['picture']['large'] as String? ?? '',
        age: (json['dob']['age'] as int?) ?? 0,
        city: json['location']['city'] as String? ?? 'Unknown',
        country: json['location']['country'] as String? ?? 'Unknown',
        isLiked: false,
      );
    } catch (e) {
      throw Exception('Error parsing user: $e, JSON: $json');
    }
  }
}
