import 'package:flutter_test/flutter_test.dart';
import 'package:mp5/model/news_model.dart';
import 'package:mp5/utils/news_api.dart';

void main() {
  test('Article.fromJson() test', () {
    final Map<String, dynamic> json = {
      'source': {'id': '1', 'name': 'News Source'},
      'author': 'Author',
      'title': 'Article Title',
      'description': 'Article Description',
      'url': 'https://example.com/article',
      'urlToImage': 'https://example.com/image.jpg',
      'publishedAt': '2022-05-03T12:00:00Z',
      'content': 'Article content...'
    };

    final article = Article.fromJson(json);
    expect(article.sourceId, '1');
    expect(article.sourceName, 'News Source');
    expect(article.author, 'Author');
    expect(article.title, 'Article Title');
    expect(article.description, 'Article Description');
    expect(article.url, 'https://example.com/article');
    expect(article.urlToImage, 'https://example.com/image.jpg');
    expect(article.publishedAt, '2022-05-03T12:00:00Z');
    expect(article.content, 'Article content...');
  });

  test('getNews() returns a valid response', () async {
    final client = NewsApiClient(apiKey: '6dfc366b756a49ee973aff043cc2c2c5');
    final response = await client.getNews(q: 'Flutter');

    expect(response.status, 'ok');
    expect(response.totalResults, greaterThan(0));
  });

}

