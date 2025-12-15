import 'package:flutter_dotenv/flutter_dotenv.dart';

String apiKey = dotenv.env['NEWS_API_KEY'] ?? '';
String baseUrl = "https://newsapi.org/v2";

String urlForYouNews = "$baseUrl/top-headlines?country=us&apiKey=$apiKey";
String urlNewsByCategory(String category, {int page = 1, int pageSize = 20}) =>
    "$baseUrl/top-headlines?country=us&category=$category&page=$page&pageSize=$pageSize&apiKey=$apiKey";
String urlSearchNews(String query, String page, String pageSize) =>
    "$baseUrl/everything?q=$query&page=$page&pageSize=$pageSize&apiKey=$apiKey";
