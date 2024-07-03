import 'package:flutter/material.dart';
import 'package:mp5/model/bookmarks_model.dart';
import 'package:mp5/model/news_model.dart';
//import 'package:mp5/views/home_page.dart';
import 'package:mp5/views/news_details_page.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({Key? key}) : super(key: key);

  @override
  BookmarksPageState createState() => BookmarksPageState();
}

class BookmarksPageState extends State<BookmarksPage> {
  Future<List<Article>> _bookmarkedArticlesFuture =
      BookmarkService.getBookmarkedArticles();

  void refreshBookmarksPage() {
    setState(() {
      _bookmarkedArticlesFuture = BookmarkService.getBookmarkedArticles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
      ),
      body: FutureBuilder<List<Article>>(
        future: _bookmarkedArticlesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<Article> bookmarkedArticles = snapshot.data ?? [];
            return ListView.builder(
              itemCount: bookmarkedArticles.length,
              itemBuilder: (context, index) {
                final article = bookmarkedArticles[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewsDetailPage(
                            article: article,
                          ),
                        ),
                      ).then((value) {
                        refreshBookmarksPage();
                      });
                    },
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: SizedBox(
                        width: 80,
                        height: 80,
                        child: Image.network(
                          article.urlToImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(
                      article.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      article.sourceName,
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
