import 'dart:convert';
import 'package:mp5/model/news_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkService {
  static Future<void> addBookmark(Article article) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? bookmarkedUrls = prefs.getStringList('bookmarked_articles');
    bookmarkedUrls ??= [];

    if (!bookmarkedUrls.contains(article.url)) {
      bookmarkedUrls.add(article.url);
      await prefs.setStringList('bookmarked_articles', bookmarkedUrls);
      await prefs.setString(article.url, jsonEncode(article.toJson()));
    }
  }

  static Future<void> removeBookmark(String url) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? bookmarkedUrls = prefs.getStringList('bookmarked_articles');
    bookmarkedUrls?.remove(url);

    await prefs.setStringList('bookmarked_articles', bookmarkedUrls ?? []);
    await prefs.remove(url);
  }

  static Future<bool> isBookmarked(String url) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? bookmarkedUrls = prefs.getStringList('bookmarked_articles');
    return bookmarkedUrls?.contains(url) ?? false;
  }

  static Future<List<Article>> getBookmarkedArticles() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? bookmarkedUrls = prefs.getStringList('bookmarked_articles');
    List<Article> bookmarkedArticles = [];

    if (bookmarkedUrls != null) {
      for (String url in bookmarkedUrls) {
        final String? articleJson = prefs.getString(url);
        if (articleJson != null) {
          final Map<String, dynamic> articleMap = jsonDecode(articleJson);
          final Article? article = Article.fromJson(articleMap);
          bookmarkedArticles.add(article!);
        }
      }
    }

    return bookmarkedArticles;
  }
}
