import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/models/categories_news_model.dart';
import 'dart:convert';

import 'package:news_app/models/news_headline_model.dart';

class NewsRepository {
  final apiKey = dotenv.env['NEWS_API_KEY'];
  Future<NewsHeadlinesModel> fetchNewsHeadlinesApi(String Source) async {
    String url =
        "https://newsapi.org/v2/top-headlines?sources=$Source&apiKey=$apiKey";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return NewsHeadlinesModel.fromJson(body);
    }
    throw Exception("Something went wrong");
  }

  Future<CategoriesNewsModel> fetchCategoriesNewsApi(String category) async {
    String url = "https://newsapi.org/v2/everything?q=$category&apiKey=$apiKey";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return CategoriesNewsModel.fromJson(body);
    }
    throw Exception("Something went wrong");
  }
}
