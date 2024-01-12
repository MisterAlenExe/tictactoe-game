// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:tictactoe_game/domain/entities/user.dart';

class GameEntity extends Equatable {
  final String uid;
  final UserEntity? firstPlayer;
  final UserEntity? secondPlayer;
  final String? currentTurn;
  final String? winner;
  final GameStatus status;
  final List<String> board;

  const GameEntity({
    required this.uid,
    required this.firstPlayer,
    required this.secondPlayer,
    required this.currentTurn,
    required this.winner,
    required this.status,
    required this.board,
  });

  @override
  List<Object?> get props =>
      [uid, firstPlayer, secondPlayer, currentTurn, winner, status, board];

  GameEntity copyWith({
    String? uid,
    UserEntity? firstPlayer,
    UserEntity? secondPlayer,
    String? currentTurn,
    String? winner,
    GameStatus? status,
    List<String>? board,
  }) {
    return GameEntity(
      uid: uid ?? this.uid,
      firstPlayer: firstPlayer ?? this.firstPlayer,
      secondPlayer: secondPlayer ?? this.secondPlayer,
      currentTurn: currentTurn ?? this.currentTurn,
      winner: winner ?? this.winner,
      status: status ?? this.status,
      board: board ?? this.board,
    );
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
