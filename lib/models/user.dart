import 'package:testing/models/tag.dart';

class User {

  final int id;
  final String username;
  final String? biography;
  final String? imageUrl;
  final String roleName;
  final List<Tag> tags;

  User({required this.id, required this.username, required this.biography, required this.imageUrl, required this.roleName, required this.tags});

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    username: json['username'],
    biography: json['biography'],
    imageUrl: json['imageUrl'],
    roleName: json['roleName'],
    tags: List<Tag>.from(json['tags'].map((item) => Tag.fromJson(item)))
  );
  
}