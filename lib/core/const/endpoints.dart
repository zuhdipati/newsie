String apiKey = "12a0a7e344184cfca34efc8789f4d840";
String baseUrl = "https://newsapi.org/v2";

String urlForYouNews = "$baseUrl/top-headlines?country=us&apiKey=$apiKey";
String urlNewsByCategory(String category) =>
    "$baseUrl/top-headlines?country=us&category=$category&apiKey=$apiKey";
String urlSearchNews(String query, String page, String pageSize) =>
    "$baseUrl/everything?q=$query&page=$page&pageSize=$pageSize&apiKey=$apiKey";
