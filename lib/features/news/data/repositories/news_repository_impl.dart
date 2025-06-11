import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:newsapp/core/error/failure.dart';
import 'package:newsapp/core/utils/toast.dart';
import 'package:newsapp/features/news/data/datasources/local_datasources.dart';
import 'package:newsapp/features/news/data/datasources/remote_datasources.dart';
import 'package:newsapp/features/news/data/models/news_model.dart';
import 'package:newsapp/features/news/domain/entities/news_category.dart';
import 'package:newsapp/features/news/domain/repositories/news_repository.dart';

class NewsRepositoryImpl extends NewsRepository {
  NewsRemoteDatasources newsRemoteDatasources;
  NewsLocalDatasources newsLocalDatasources;
  Box box;

  NewsRepositoryImpl({
    required this.newsRemoteDatasources,
    required this.newsLocalDatasources,
    required this.box,
  });

  @override
  Future<Either<Failure, List<NewsEntity>>> getForYouNews() async {
    bool result = await InternetConnection().hasInternetAccess;

    try {
      if (result == false) {
        List<NewsModel> result = await newsLocalDatasources.getForYouNews();
        ToastUtils.error('No Internet Connection');
        return Right(result.map((e) => e.toEntity()).toList());
      } else {
        List<NewsModel> result = await newsRemoteDatasources.getForYouNews();
        box.put("getForYouNews", result);
        return Right(result.map((e) => e.toEntity()).toList());
      }
    } catch (e) {
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, List<NewsEntity>>> getNewsByCategory(
      String category) async {
    bool result = await InternetConnection().hasInternetAccess;
    try {
      if (result == false) {
        List<NewsModel> result =
            await newsLocalDatasources.getNewsByCategory(category);
        ToastUtils.error('No Internet Connection');
        return Right(result.map((e) => e.toEntity()).toList());
      } else {
        List<NewsModel> result =
            await newsRemoteDatasources.getNewsByCategory(category);
        box.put("getNewsByCategory", result);
        return Right(result.map((e) => e.toEntity()).toList());
      }
    } catch (e) {
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, List<NewsEntity>>> getSearchNews(
      String query, String page, String pageSize) async {
    bool result = await InternetConnection().hasInternetAccess;
    try {
      if (result == false) {
        ToastUtils.error('No Internet Connection');
        throw Exception(['no internet']);
      } else {
        List<NewsModel> result =
            await newsRemoteDatasources.getSearchNews(query, page, pageSize);
        box.put("getNewsByCategory", result);
        return Right(result.map((e) => e.toEntity()).toList());
      }
    } catch (e) {
      ToastUtils.success(e.toString());
      return Left(Failure());
    }
  }
}
