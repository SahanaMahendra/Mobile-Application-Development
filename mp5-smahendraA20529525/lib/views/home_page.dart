import 'package:flutter/material.dart';
import 'package:mp5/model/news_model.dart';
import 'package:mp5/utils/news_api.dart';
import 'package:mp5/views/bookmarks.dart';
import 'package:mp5/views/news_details_page.dart';
import 'package:mp5/views/search_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final NewsApiClient newsApiClient =
      NewsApiClient(apiKey: '6dfc366b756a49ee973aff043cc2c2c5');

  Future<void> _refresh() async {
    await newsApiClient.getTopHeadlines();
    setState(() {});
  }

  List<Article> filterRemovedArticles(List<Article> articles) {
    return articles
        .where((article) => article.sourceName != "[Removed]")
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Headlines'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refresh,
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder<NewsResponse>(
        future: newsApiClient.getTopHeadlines(),
        builder: (context, AsyncSnapshot<NewsResponse> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final newsResponse = snapshot.data;

            if (newsResponse != null && newsResponse.articles.isNotEmpty) {
              final filteredArticles =
                  filterRemovedArticles(newsResponse.articles);

              return ListView.builder(
                itemCount: filteredArticles.length,
                itemBuilder: (context, index) {
                  final article = filteredArticles[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              NewsDetailPage(article: article),
                        ),
                      );
                    },
                    child: NewsListItem(
                      title: article.title,
                      imageUrl: article.urlToImage,
                    ),
                  );
                },
              );
            } else {
              return const Center(child: Text('No articles found.'));
            }
          }
        },
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 111, 126, 137),
            ),
            child: Center(
              child: Text(
                'InfoStream',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                ),
              ),
            ),
          ),
          ListTile(
            title: const Text('Search'),
            leading: const Icon(Icons.search),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SearchPage()));
            },
          ),
          ListTile(
            title: const Text('Bookmarks'),
            leading: const Icon(Icons.bookmark),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const BookmarksPage()));
            },
          ),
          ListTile(
            title: const Text('Settings'),
            leading: const Icon(Icons.settings),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class NewsListItem extends StatelessWidget {
  final String title;
  final String? imageUrl;

  const NewsListItem({
    Key? key,
    required this.title,
    this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
  margin: const EdgeInsets.symmetric(horizontal: 8.0), // Add margin here
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      if (imageUrl != null && Uri.parse(imageUrl!).isAbsolute)
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Image.network(
            imageUrl!,
            fit: BoxFit.cover,
          ),
        ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    ],
  ),
);
  }
}