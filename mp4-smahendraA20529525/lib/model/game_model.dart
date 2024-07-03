class Game {
  final int id;
  final String player1;
  final String player2;
  final int position;
  final int status;
  final int turn;

  Game({
    required this.id,
    required this.player1,
    required this.player2,
    required this.position,
    required this.status,
    required this.turn,
  });

  String getPlayerName(int playerNumber) => playerNumber == 1 ? player1 : player2;

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'] as int? ?? 0,
      player1: json['player1'] as String? ?? '',
      player2: json['player2'] as String? ?? '',
      position: json['position'] as int? ?? 0,
      status: json['status'] as int? ?? 0,
      turn: json['turn'] as int? ?? 0,
    );
  }
}
