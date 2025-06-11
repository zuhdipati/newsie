import 'package:dartz/dartz.dart';
import 'package:newsapp/core/error/failure.dart';
import 'package:newsapp/features/news/domain/entities/news_category.dart';
import 'package:newsapp/features/news/domain/repositories/news_repository.dart';

class GetNewsByCategory {
  final NewsRepository newsRepository;

  GetNewsByCategory({required this.newsRepository});

  Future<Either<Failure, List<NewsEntity>>> call(String category) async {
    return await newsRepository.getNewsByCategory(category);
  }
}
