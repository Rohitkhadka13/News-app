import 'package:news_app/models/news_headline_model.dart';
import 'package:news_app/repository/news_repository.dart';

class NewsViewModel {
  final _rep = NewsRepository();


  Future<NewsHeadlinesModel> fetchNewsHeadlines() async {
  final response =   await _rep.fetchNewsHeadlinesApi();
  return response;
  }
}
