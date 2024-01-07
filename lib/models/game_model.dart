import 'package:tictactoe_game/models/user_model.dart';

class Game {
  final String uid;
  final List<User?> players;
  final String? currentTurn;
  final String? winner;
  final GameStatus status;
  final List<String> board;

  Game({
    required this.uid,
    required this.players,
    required this.currentTurn,
    required this.winner,
    required this.status,
    required this.board,
  });

  factory Game.fromFirestore(Map<String, dynamic> firestore) {
    List<User?> players = [
      User(
        uid: firestore['players'][0]['uid'],
        email: firestore['players'][0]['email'],
      ),
      User(
        uid: firestore['players'][1]['uid'],
        email: firestore['players'][1]['email'],
      ),
    ];

    return Game(
      uid: firestore['uid'],
      players: players,
      currentTurn: firestore['currentTurn'],
      winner: firestore['winner'],
      status: GameStatusX.fromName(firestore['status']),
      board: List<String>.from(firestore['board']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'players': players.map((player) => player!.toFirestore()).toList(),
      'currentTurn': currentTurn,
      'winner': winner,
      'status': status.name,
      'board': board,
    };
  }

  Game copyWith({
    String? uid,
    List<User?>? players,
    String? currentTurn,
    String? winner,
    GameStatus? status,
    List<String>? board,
  }) {
    return Game(
      uid: uid ?? this.uid,
      players: players ?? this.players,
      currentTurn: currentTurn ?? this.currentTurn,
      winner: winner ?? this.winner,
      status: status ?? this.status,
      board: board ?? this.board,
    );
  }

  @override
  String toString() {
    return 'Game(uid: $uid, players: $players, currentTurn: $currentTurn, winner: $winner, status: $status, board: $board)';
  }
}

enum GameStatus {
  waiting,
  playing,
  finished,
}

extension GameStatusX on GameStatus {
  String get name {
    switch (this) {
      case GameStatus.waiting:
        return 'waiting';
      case GameStatus.playing:
        return 'playing';
      case GameStatus.finished:
        return 'finished';
      default:
        return 'waiting';
    }
  }

  static GameStatus fromName(String name) {
    switch (name) {
      case 'waiting':
        return GameStatus.waiting;
      case 'playing':
        return GameStatus.playing;
      case 'finished':
        return GameStatus.finished;
      default:
        return GameStatus.waiting;
    }
  }
}
