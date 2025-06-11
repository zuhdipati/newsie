import 'package:dartz/dartz.dart';
import 'package:newsapp/core/error/failure.dart';
import 'package:newsapp/features/news/domain/entities/news_category.dart';
import 'package:newsapp/features/news/domain/repositories/news_repository.dart';

class GetSearchNews {
  final NewsRepository newsRepository;

  GetSearchNews({required this.newsRepository});

  Future<Either<Failure, List<NewsEntity>>> call(
      String query, String page, String pageSize) async {
    return await newsRepository.getSearchNews(query, page, pageSize);
  }
}
