import 'package:dartz/dartz.dart';
import 'package:newsapp/core/error/failure.dart';
import 'package:newsapp/features/news/domain/entities/news_category.dart';

abstract class NewsRepository {
  Future<Either<Failure, List<NewsEntity>>> getForYouNews();
  Future<Either<Failure, List<NewsEntity>>> getNewsByCategory(
      String category);
  Future<Either<Failure, List<NewsEntity>>> getSearchNews(
      String query, String page, String pageSize);
}
