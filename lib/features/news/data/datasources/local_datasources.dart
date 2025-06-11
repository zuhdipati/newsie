import 'package:hive/hive.dart';
import 'package:newsapp/features/news/data/models/news_model.dart';

abstract class NewsLocalDatasources {
  Future<List<NewsModel>> getForYouNews();
  Future<List<NewsModel>> getNewsByCategory(String category);
}

class NewsLocalDataImpl extends NewsLocalDatasources {
  final Box box;

  NewsLocalDataImpl({required this.box});

  @override
  Future<List<NewsModel>> getForYouNews() async {
    final List<dynamic>? rawData = box.get("getAllNews");
    if (rawData == null) return [];
    return rawData.cast<NewsModel>();
  }

  @override
  Future<List<NewsModel>> getNewsByCategory(String category) async {
    final List<dynamic>? rawData = box.get("getNewsByCategory");
    if (rawData == null) return [];
    return rawData.cast<NewsModel>();
  }
}
