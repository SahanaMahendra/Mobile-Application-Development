import 'package:flutter/material.dart';
import 'package:mp3/views/cardInputPage.dart';
import 'package:mp3/views/quizPlayPage.dart';
import 'package:provider/provider.dart';
import '../models/model_class.dart';

enum SortMode { byID, alphabetical }

class QuizList extends StatefulWidget {
  final Decks deck;

  const QuizList({Key? key, required this.deck}) : super(key: key);

  @override
  State<QuizList> createState() => _QuizListState();
}

class _QuizListState extends State<QuizList> {
  SortMode _currentSortMode = SortMode.byID;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    const double desiredCardWidth = 150.0;
    int cardsWidth = (screenWidth / desiredCardWidth).floor();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.deck.name),
        actions: [
          IconButton(
            icon: _currentSortMode == SortMode.byID
                ? const Icon(Icons.access_time)
                : const Icon(Icons.sort_by_alpha),
            onPressed: _toggleSortMode,
          ),
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: _navigateToQuizPlayPage,
          )
        ],
      ),
      body: Consumer<DataNotifier>(
        builder: (context, dataNotifier, _) {
          return FutureBuilder<List<Qcards>>(
            future: dataNotifier.getQcardsForDeck(widget.deck.id!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                List<Qcards> cards = snapshot.data!;
                _sortCards(cards);

                if (cards.isNotEmpty) {
                  return GridView.builder(
                    padding: const EdgeInsets.all(5.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: cardsWidth,
                      childAspectRatio: 1,
                    ),
                    itemCount: cards.length,
                    itemBuilder: (context, index) {
                      final qcard = cards[index];
                      return _buildQuizCard(qcard);
                    },
                  );
                } else {
                  return const Center(child: Text('No cards in this deck.'));
                }
              } else {
                return const Center(child: Text('Failed to load cards.'));
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCardInputPage,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _toggleSortMode() {
    setState(() {
      _currentSortMode = _currentSortMode == SortMode.byID
          ? SortMode.alphabetical
          : SortMode.byID;
    });
  }

  void _navigateToQuizPlayPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizPlayPage(deck: widget.deck),
      ),
    );
  }

  void _navigateToCardInputPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CardInputPage(deckId: widget.deck.id),
      ),
    );
  }

  void _sortCards(List<Qcards> cards) {
    if (_currentSortMode == SortMode.byID) {
      cards.sort((a, b) => a.id!.compareTo(b.id!));
    } else {
      cards.sort((a, b) => a.question.compareTo(b.question));
    }
  }

  Widget _buildQuizCard(Qcards qcard) {
    return InkWell(
      onTap: () => _navigateToCardInputPageWithCard(qcard),
      child: Card(
        color: Colors.blue[100],
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  qcard.question,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToCardInputPageWithCard(Qcards qcard) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            CardInputPage(card: qcard, deckId: widget.deck.id),
      ),
    );
  }
}
