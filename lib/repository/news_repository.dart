import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:news_app/models/news_headline_model.dart';

class NewsRepository {
  Future<NewsHeadlinesModel> fetchNewsHeadlinesApi() async {
    String url =
        "https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=4a38da3af30f45d681ba4d6df61b0100";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      print(response.body);
      final body = jsonDecode(response.body);
      return NewsHeadlinesModel.fromJson(body);
    }
    throw Exception("Something went wrong");
  }
}
