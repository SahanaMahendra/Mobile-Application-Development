import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/model_class.dart';

class QuizPlayPage extends StatefulWidget {
  final Decks deck;

  const QuizPlayPage({super.key, required this.deck});

  @override
  QuizPlayPageState createState() => QuizPlayPageState();
}

class QuizPlayPageState extends State<QuizPlayPage> {
  bool showAnswer = false;
  int currentIndex = 0;
  int viewedCount = 1;
  int peekedCount = 0;
  Set<int> viewedCardsSet = {};
  Set<int> peekedCardsSet = {};
  late Future<List<Qcards>> cardsFuture;

  @override
  void initState() {
    super.initState();
    cardsFuture = _getAndShuffleCards();
    viewedCardsSet.add(currentIndex);
  }

  Future<List<Qcards>> _getAndShuffleCards() async {
    final cards = await Provider.of<DataNotifier>(context, listen: false)
        .getQcardsForDeck(widget.deck.id!);
    return List.from(cards)..shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.deck.name)),
      body: FutureBuilder<List<Qcards>>(
        future: cardsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              List<Qcards> shuffledCards = snapshot.data!;
              return Column(
                children: [
                  _buildCard(shuffledCards),
                  _buildControls(shuffledCards),
                ],
              );
            } else {
              return const Center(child: Text('No cards in this deck.'));
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildCard(List<Qcards> shuffledCards) {
    return Flexible(
      flex: 7,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          color: showAnswer ? Colors.green[100] : Colors.blue[100],
          margin: const EdgeInsets.all(8.0),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                showAnswer ? shuffledCards[currentIndex].answer : shuffledCards[currentIndex].question,
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildControls(List<Qcards> shuffledCards) {
    return Flexible(
      flex: 6,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => _navigateToPreviousCard(shuffledCards),
              ),
              IconButton(
                icon: showAnswer
                    ? const Icon(Icons.flip_to_front)
                    : const Icon(Icons.flip_to_back),
                onPressed: _toggleAnswer,
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () => _navigateToNextCard(shuffledCards),
              ),
            ],
          ),
          _buildCardStatistics(shuffledCards),
        ],
      ),
    );
  }

  void _navigateToPreviousCard(List<Qcards> shuffledCards) {
    setState(() {
      currentIndex = currentIndex == 0 ? shuffledCards.length - 1 : currentIndex - 1;
      showAnswer = false;
      _updateCardCount(shuffledCards);
    });
  }

  void _navigateToNextCard(List<Qcards> shuffledCards) {
    setState(() {
      currentIndex = currentIndex == shuffledCards.length - 1 ? 0 : currentIndex + 1;
      showAnswer = false;
      _updateCardCount(shuffledCards);
    });
  }

  void _toggleAnswer() {
    setState(() {
      showAnswer = !showAnswer;
      if (showAnswer && !peekedCardsSet.contains(currentIndex)) {
        peekedCount++;
        peekedCardsSet.add(currentIndex);
      }
    });
  }

  void _updateCardCount(List<Qcards> shuffledCards) {
    viewedCardsSet.add(currentIndex);
    viewedCount = viewedCardsSet.length;
  }

  Widget _buildCardStatistics(List<Qcards> shuffledCards) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Seen $viewedCount of ${shuffledCards.length} cards"),
          const SizedBox(height: 15),
          Text("Peeked at $peekedCount of $viewedCount answers"),
        ],
      ),
    );
  }
}
