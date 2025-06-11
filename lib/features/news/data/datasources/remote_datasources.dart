import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:newsapp/core/const/endpoints.dart';
import 'package:newsapp/core/error/exception.dart';
import 'package:newsapp/features/news/data/models/news_model.dart';

abstract class NewsRemoteDatasources {
  Future<List<NewsModel>> getForYouNews();
  Future<List<NewsModel>> getNewsByCategory(String category);
  Future<List<NewsModel>> getSearchNews(
      String query, String page, String pageSize);
}

class NewsRemoteDataImpl extends NewsRemoteDatasources {
  http.Client client;

  NewsRemoteDataImpl({required this.client});
  @override
  Future<List<NewsModel>> getForYouNews() async {
    try {
      Uri url = Uri.parse(urlForYouNews);
      var response = await client.get(url).timeout(Duration(seconds: 30));
      var dataBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        List<dynamic> data = dataBody['articles'];
        return NewsModel.fromJsonList(data);
      } else {
        throw GeneralException(message: "Can't Get Data");
      }
    } on TimeoutException {
      throw GeneralException(message: "Request timed out. Please try again.");
    } catch (e) {
      throw GeneralException(message: "An unexpected error occurred: $e");
    }
  }

  @override
  Future<List<NewsModel>> getNewsByCategory(String category) async {
    try {
      Uri url = Uri.parse(urlNewsByCategory(category));
      var response = await client.get(url).timeout(Duration(seconds: 30));
      var dataBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        List<dynamic> data = dataBody['articles'];
        return NewsModel.fromJsonList(data);
      } else {
        throw GeneralException(message: "Can't Get Data");
      }
    } on TimeoutException {
      throw GeneralException(message: "Request timed out. Please try again.");
    } catch (e) {
      throw GeneralException(message: "An unexpected error occurred: $e");
    }
  }

  @override
  Future<List<NewsModel>> getSearchNews(
      String query, String page, String pageSize) async {
    try {
      Uri url = Uri.parse(urlSearchNews(query, page, pageSize));
      var response = await client.get(url).timeout(Duration(seconds: 30));
      var dataBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        List<dynamic> data = dataBody['articles'];
        return NewsModel.fromJsonList(data);
      } else {
        throw GeneralException(message: "Can't Get Data");
      }
    } on TimeoutException {
      throw GeneralException(message: "Request timed out. Please try again.");
    } catch (e) {
      throw GeneralException(message: "An unexpected error occurred: $e");
    }
  }
}
