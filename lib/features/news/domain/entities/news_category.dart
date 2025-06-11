import 'package:equatable/equatable.dart';

class NewsEntity extends Equatable {
  final String id;
  final String author;
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String publishedAt;

  const NewsEntity({
    required this.id,
    required this.author,
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
  });

  @override
  List<Object?> get props =>
      [id, author, title, description, url, urlToImage, publishedAt];
}
