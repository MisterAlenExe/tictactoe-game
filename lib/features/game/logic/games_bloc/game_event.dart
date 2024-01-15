part of 'game_bloc.dart';

sealed class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object> get props => [];
}

final class GetGamesListEvent extends GameEvent {
  const GetGamesListEvent();

  @override
  List<Object> get props => [];
}

final class GetGameByIdEvent extends GameEvent {
  final String uid;

  const GetGameByIdEvent({
    required this.uid,
  });

  @override
  List<Object> get props => [uid];
}

final class CreateGameEvent extends GameEvent {
  final UserModel player;

  const CreateGameEvent({
    required this.player,
  });

  @override
  List<Object> get props => [player];
}

final class JoinGameEvent extends GameEvent {
  final GameModel game;
  final UserModel player;

  const JoinGameEvent({
    required this.game,
    required this.player,
  });

  @override
  List<Object> get props => [game, player];
}

final class MakeMoveEvent extends GameEvent {
  final GameModel game;
  final int index;

  const MakeMoveEvent({
    required this.game,
    required this.index,
  });

  @override
  List<Object> get props => [game, index];
}
