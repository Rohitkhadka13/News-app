import 'package:http/http.dart' as http;
import 'package:news_app/models/categories_news_model.dart';
import 'dart:convert';

import 'package:news_app/models/news_headline_model.dart';

class NewsRepository {
  Future<NewsHeadlinesModel> fetchNewsHeadlinesApi(String Source) async {
    String url =
        "https://newsapi.org/v2/top-headlines?sources=$Source&apiKey=4a38da3af30f45d681ba4d6df61b0100";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return NewsHeadlinesModel.fromJson(body);
    }
    throw Exception("Something went wrong");
  }

  Future<CategoriesNewsModel> fetchCategoriesNewsApi(String category) async {
    String url =
        "https://newsapi.org/v2/everything?q=$category&apiKey=4a38da3af30f45d681ba4d6df61b0100";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return CategoriesNewsModel.fromJson(body);
    }
    throw Exception("Something went wrong");
  }
}
