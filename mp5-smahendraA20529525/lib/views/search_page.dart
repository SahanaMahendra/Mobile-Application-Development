import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:mp5/model/news_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/news_api.dart';
import 'search_results_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _recentSearches = [];
  bool _searchInTitle = true;
  bool _searchInDescription = true;
  bool _searchInContent = true;
  String _selectedSource = "";
  final String _selectedDomain = "";
  final String _excludedDomain = "";
  DateTime? _fromDate;
  DateTime? _toDate;
  final String _selectedLanguage = "en";
  String _sortBy = "publishedAt";
  final int _pageSize = 20;
  final int _page = 1;

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
  }

  Future<void> _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    final recentSearches = prefs.getStringList('recentSearches') ?? [];
    setState(() {
      _recentSearches.addAll(recentSearches);
    });
  }

  Future<void> _saveRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('recentSearches', _recentSearches);
  }

  Future<void> _search() async {
    try {
      final NewsResponse searchResults =
          await NewsApiClient(apiKey: '318b6b3ed9104f23985940218639a872')
              .getNews(
        q: _searchController.text,
        searchIn: _searchInTitle
            ? 'title'
            : (_searchInDescription
                ? 'description'
                : (_searchInContent ? 'content' : null)),
        sources: _selectedSource,
        domains: _selectedDomain,
        excludeDomains: _excludedDomain,
        from: _fromDate?.toIso8601String(),
        to: _toDate?.toIso8601String(),
        language: _selectedLanguage,
        sortBy: _sortBy,
        pageSize: _pageSize,
        page: _page,
      );
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResultsPage(searchResults: searchResults),
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error during search: $e');
      }
    }

    if (!_recentSearches.contains(_searchController.text)) {
      _recentSearches.insert(0, _searchController.text);
      if (_recentSearches.length > 5) {
        _recentSearches.removeLast();
      }
      _saveRecentSearches();
    }
  }

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != (isFromDate ? _fromDate : _toDate)) {
      setState(() {
        if (isFromDate) {
          _fromDate = picked;
        } else {
          _toDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
               key: Key('search_field'), // Add this line to assign the key
               controller: _searchController,
               decoration: const InputDecoration(
               labelText: 'Search',
               ),
               ),
              const SizedBox(height: 16.0),
              const Text(
                'Search In:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              CheckboxListTile(
                title: const Text('Title'),
                value: _searchInTitle,
                onChanged: (value) {
                  setState(() {
                    _searchInTitle = value ?? false;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Description'),
                value: _searchInDescription,
                onChanged: (value) {
                  setState(() {
                    _searchInDescription = value ?? false;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Content'),
                value: _searchInContent,
                onChanged: (value) {
                  setState(() {
                    _searchInContent = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Sources:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextField(
                onChanged: (value) {
                  setState(() {
                    _selectedSource = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Selected Source',
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'From:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _fromDate?.toLocal().toString() ?? 'Select Date',
                    ),
                  ),
                  TextButton(
                    onPressed: () => _selectDate(context, true),
                    child: const Text('Select Date'),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              const Text(
                'To:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _toDate?.toLocal().toString() ?? 'Select Date',
                    ),
                  ),
                  TextButton(
                    onPressed: () => _selectDate(context, false),
                    child: const Text('Select Date'),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Sort By:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                value: _sortBy,
                onChanged: (String? value) {
                  setState(() {
                    _sortBy = value ?? "publishedAt";
                  });
                },
                items: <String>['relevancy', 'popularity', 'publishedAt']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: _search,
                child: const Text('Search'),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Recent Searches:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Wrap(
                spacing: 8.0,
                children: _recentSearches
                    .map(
                      (query) => GestureDetector(
                        onTap: () {
                          _searchController.text = query;
                        },
                        child: Chip(
                          label: Text(query),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
