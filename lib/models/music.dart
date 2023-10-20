import 'package:testing/models/tag.dart';
import 'package:testing/models/user.dart';

class Music {

  final int id;
  final String name;
  final String description;
  final String? imageUrl;
  final String audioUrl;
  final User author;
  final List<Tag> tags;
  int likesCount;
  bool isLiked;

  Music({required this.id, required this.name, required this.description, required this.imageUrl, required this.audioUrl, required this.author, required this.tags, required this.likesCount, required this.isLiked});

  factory Music.fromJson(Map<String, dynamic> json) => Music(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    imageUrl: json['imageUrl'],
    audioUrl: json['audioUrl'],
    author: User.fromJson(json['author']),
    tags: List<Tag>.from(json['tags'].map((item) => Tag.fromJson(item))),
    likesCount: json['likesCount'],
    isLiked: json['isLiked']
  );

}