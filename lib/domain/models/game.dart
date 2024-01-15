import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tictactoe_game/domain/models/user.dart';

part 'game.g.dart';

@JsonSerializable()
class GameModel extends Equatable {
  final String uid;
  final UserModel? firstPlayer;
  final UserModel? secondPlayer;
  final String? currentTurn;
  final String? winner;
  final GameStatus status;
  final List<String> board;

  const GameModel({
    required this.uid,
    required this.firstPlayer,
    required this.secondPlayer,
    required this.currentTurn,
    required this.winner,
    required this.status,
    required this.board,
  });

  GameModel copyWith({
    String? uid,
    UserModel? firstPlayer,
    UserModel? secondPlayer,
    String? currentTurn,
    String? winner,
    GameStatus? status,
    List<String>? board,
  }) {
    return GameModel(
      uid: uid ?? this.uid,
      firstPlayer: firstPlayer ?? this.firstPlayer,
      secondPlayer: secondPlayer ?? this.secondPlayer,
      currentTurn: currentTurn ?? this.currentTurn,
      winner: winner ?? this.winner,
      status: status ?? this.status,
      board: board ?? this.board,
    );
  }

  factory GameModel.fromJson(Map<String, dynamic> json) {
    return GameModel(
      uid: json['uid'] as String,
      firstPlayer: json['firstPlayer'] == null
          ? null
          : UserModel.fromJson(json['firstPlayer'] as Map<String, dynamic>),
      secondPlayer: json['secondPlayer'] == null
          ? null
          : UserModel.fromJson(json['secondPlayer'] as Map<String, dynamic>),
      currentTurn: json['currentTurn'] as String?,
      winner: json['winner'] as String?,
      status: $enumDecode(_$GameStatusEnumMap, json['status']),
      board: (json['board'] as List<dynamic>).map((e) => e as String).toList(),
    );
  }

  Map<String, dynamic> toJson() => _$GameModelToJson(this);

  @override
  List<Object?> get props =>
      [uid, firstPlayer, secondPlayer, currentTurn, winner, status, board];
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
