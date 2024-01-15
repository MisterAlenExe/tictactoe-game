part of 'game_bloc.dart';

abstract class GameState extends Equatable {}

final class GameStateInitial extends GameState {
  GameStateInitial();

  @override
  List<Object?> get props => [];
}

final class GameLoadingState extends GameState {
  GameLoadingState();

  @override
  List<Object?> get props => [];
}

final class GamesLoadedState extends GameState {
  final List<GameModel> games;

  GamesLoadedState({
    required this.games,
  });

  @override
  List<Object?> get props => [games];
}

final class GameLoadedState extends GameState {
  final GameModel game;

  GameLoadedState({
    required this.game,
  });

  @override
  List<Object?> get props => [game];
}

final class GameCreatedState extends GameState {
  GameCreatedState();

  @override
  List<Object?> get props => [];
}

final class GameJoinedState extends GameState {
  GameJoinedState();

  @override
  List<Object?> get props => [];
}

final class GameMoveMadeState extends GameState {
  GameMoveMadeState();

  @override
  List<Object?> get props => [];
}

final class GameErrorState extends GameState {
  final String message;

  GameErrorState({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}
