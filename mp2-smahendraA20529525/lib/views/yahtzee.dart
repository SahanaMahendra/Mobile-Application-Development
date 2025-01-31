import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/models/dice.dart';
import '/models/scorecard.dart';
import '/models/diceWidget.dart';


class Yahtzee extends StatelessWidget {
  const Yahtzee({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yahtzee',
      debugShowCheckedModeBanner:
          false,
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => Dice(5)),
          ChangeNotifierProvider(create: (_) => ScoreCard()),
        ],
        child: _DiceScreen(),
      ),
    );
  }
}

class _DiceScreen extends StatefulWidget {
  @override
  _DiceScreenState createState() => _DiceScreenState();
}

class _DiceScreenState extends State<_DiceScreen> {
  final dice = Dice(5);
  final scoreCard = ScoreCard();
  final Map<ScoreCategory, int?> potentialScores = {};
  bool diceroll = false;
  int rollCount = 3;

 /* void toggleHold(int index) {
    setState(() {
      dice.toggleHold(index);
    });
  } */

  void toggleHold(int index) {
  if (diceroll) {
    setState(() {
      dice.toggleHold(index);
    });
  }
}

  void updatePotentialScores() {
    for (var category in ScoreCategory.values) {
      var tempCard = ScoreCard();
      tempCard.registerScore(category, dice.values);
      potentialScores[category] = tempCard[category];
    }
  }

  void _showGameOverDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Color.fromARGB(255, 227, 247, 228),
        title: const Text('Congrats! Game Over'),
        content: Text('Your Final Score is: ${scoreCard.total}'),
        actions: [
          TextButton(
            child: const Text('Exit', style: TextStyle(color: Colors.black)),
            onPressed: () {
              // Close the game page or exit the window
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Pop twice to exit the game page
            },
          ),
          TextButton(
            child: const Text('New Game', style: TextStyle(color: Colors.black)),
            onPressed: () {
              _resetGame();
              Navigator.of(context).pop(); // Pop once to close the dialog
            },
          ),
        ],
      );
    },
  );
}

  void _resetGame() {
    setState(() {
      dice.clear();
      scoreCard.clear();
      rollCount = 3;
      diceroll = false;
      potentialScores.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(133, 193, 201, 194),
      appBar: AppBar(
        backgroundColor: Colors .green,
        title: const Text('Yahtzee'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: dice.values.asMap().entries.map((entry) {
                int idx = entry.key;
                int value = entry.value;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DiceWidget(
                    value: value,
                    isHeld: dice.isHeld(idx),
                    onTap: () {
                      toggleHold(idx);
                    },
                  ),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: rollCount > 0
                  ? () {
                      setState(() {
                        dice.roll();
                        rollCount--;
                        updatePotentialScores();
                        diceroll = true;
                      });
                    }
                  : null,
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.green)),
              child: Text('Roll Dice $rollCount', style: TextStyle(color: Colors.black)),
            ),
            scorecalc(),
            if (!scoreCard.completed)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Current Score: ${scoreCard.total}',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }

 Widget scorecalc() {
  int numColumns = 2; // Number of columns in each row
  int numRows = (ScoreCategory.values.length / numColumns).ceil();

  return Table(
    border: TableBorder.all(),
    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
    children: List.generate(
      numRows,
      (rowIndex) {
        int startIndex = rowIndex * numColumns;
        int endIndex = (rowIndex + 1) * numColumns;

        return TableRow(
          children: List.generate(
            endIndex - startIndex,
            (columnIndex) {
              int index = startIndex + columnIndex;
              if (index < ScoreCategory.values.length) {
                return _buildScoreItem(ScoreCategory.values[index]);
              } else {
                // Placeholder widget for empty cells if the index is out of range
                return Container();
              }
            },
          ),
        );
      },
    ),
  );
}

  Widget _buildScoreItem(ScoreCategory category) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (scoreCard[category] == null && diceroll) {
            setState(() {
              scoreCard.registerScore(category, dice.values);
              rollCount = 3;
              diceroll = false;
              dice.clear();
              if (scoreCard.completed) {
                _showGameOverDialog();
              }
              for (var category in ScoreCategory.values) {
                potentialScores[category] = null;
              }
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Score already registered!')));
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Row(
            children: [
              Text(
                category.name,
                style: TextStyle(
                  fontSize: 14,
                  color: scoreCard[category] != null
                      ? Colors
                          .green 
                      : Colors
                          .black,
                ),
              ),
              const Spacer(),
              if (scoreCard[category] != null)
                Text(
                  scoreCard[category]!.toString(),
                  style: const TextStyle(fontSize: 14, color: Colors.green),
                ),
              if (scoreCard[category] == null &&
                  potentialScores[category] != null &&
                  dice.values != [0])
                Text(
                  "${potentialScores[category]!}",
                  style: const TextStyle(
                      fontSize: 14, color: Color.fromARGB(255, 221, 66, 66)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}