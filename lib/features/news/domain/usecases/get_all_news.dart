import 'package:dartz/dartz.dart';
import 'package:newsapp/core/error/failure.dart';
import 'package:newsapp/features/news/domain/entities/news_category.dart';
import 'package:newsapp/features/news/domain/repositories/news_repository.dart';

class GetAllNews {
  final NewsRepository newsRepository;

  GetAllNews({required this.newsRepository});

  Future<Either<Failure, List<NewsEntity>>> call() async {
    return await newsRepository.getForYouNews();
  }
}
