import 'package:tictactoe_game/data/models/user_model.dart';
import 'package:tictactoe_game/domain/entities/game.dart';
import 'package:tictactoe_game/domain/entities/user.dart';

class GameModel extends GameEntity {
  const GameModel({
    required String uid,
    required UserModel? firstPlayer,
    required UserModel? secondPlayer,
    required String? currentTurn,
    required String? winner,
    required GameStatus status,
    required List<String> board,
  }) : super(
          uid: uid,
          firstPlayer: firstPlayer,
          secondPlayer: secondPlayer,
          currentTurn: currentTurn,
          winner: winner,
          status: status,
          board: board,
        );

  factory GameModel.fromJson(Map<String, dynamic> json) {
    return GameModel(
      uid: json['uid'] ?? '',
      firstPlayer: UserModel.fromJson(json['firstPlayer']),
      secondPlayer: UserModel.fromJson(json['secondPlayer']),
      currentTurn: json['currentTurn'],
      winner: json['winner'],
      status: GameStatusX.fromName(json['status']),
      board: (json['board'] as List).map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'firstPlayer': firstPlayer?.toJson(),
      'secondPlayer': secondPlayer?.toJson(),
      'currentTurn': currentTurn,
      'winner': winner,
      'status': status.name,
      'board': board,
    };
  }

  GameEntity toEntity() {
    return GameEntity(
      uid: uid,
      firstPlayer: firstPlayer,
      secondPlayer: secondPlayer,
      currentTurn: currentTurn,
      winner: winner,
      status: status,
      board: board,
    );
  }

  factory GameModel.fromEntity(GameEntity gameEntity) {
    return GameModel(
      uid: gameEntity.uid,
      firstPlayer: UserModel.fromEntity(
        gameEntity.firstPlayer ?? const UserEntity.empty(),
      ),
      secondPlayer: UserModel.fromEntity(
        gameEntity.secondPlayer ?? const UserEntity.empty(),
      ),
      currentTurn: gameEntity.currentTurn,
      winner: gameEntity.winner,
      status: gameEntity.status,
      board: gameEntity.board,
    );
  }
}
