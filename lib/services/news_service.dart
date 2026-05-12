import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';

class NewsService {
  final String _apiKey = 'd81jnt9r01qrojfbs730d81jnt9r01qrojfbs73g';
  final String _baseUrl = 'https://finnhub.io/api/v1/news';

  Future<List<News>> getLatestNews() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl?category=general&token=$_apiKey'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        // Map to News objects and take only the first 20
        return data
            .map((json) => News.fromJson(json))
            .take(20)
            .toList();
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      debugPrint('Error fetching news: $e');
      return [];
    }
  }
}
