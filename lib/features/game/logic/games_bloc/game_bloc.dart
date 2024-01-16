import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tictactoe_game/domain/models/game.dart';
import 'package:tictactoe_game/domain/models/user.dart';
import 'package:tictactoe_game/domain/usecases/game/create_game.dart';
import 'package:tictactoe_game/domain/usecases/game/get_game_by_id.dart';
import 'package:tictactoe_game/domain/usecases/game/get_games.dart';
import 'package:tictactoe_game/domain/usecases/game/join_game.dart';
import 'package:tictactoe_game/domain/usecases/game/make_move.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final GetGamesUseCase getGamesUseCase;
  final GetGameByIdUseCase getGameByIdUseCase;
  final CreateGameUseCase createGameUseCase;
  final JoinGameUseCase joinGameUseCase;
  final MakeMoveUseCase makeMoveUseCase;

  GameBloc({
    required this.getGamesUseCase,
    required this.getGameByIdUseCase,
    required this.createGameUseCase,
    required this.joinGameUseCase,
    required this.makeMoveUseCase,
  }) : super(GameStateInitial()) {
    on<GetGamesListEvent>(_onGetGames);
    on<GetGameByIdEvent>(_onGetGameById);
    on<CreateGameEvent>(_onCreateGame);
    on<JoinGameEvent>(_onJoinGame);
    on<MakeMoveEvent>(_onMakeMove);
  }

  _onGetGames(
    GetGamesListEvent event,
    Emitter<GameState> emit,
  ) async {
    emit(GameLoadingState());

    final result = getGamesUseCase.execute();

    await for (final event in result) {
      event.fold(
        (failure) => emit(GameErrorState(message: failure.message)),
        (games) => emit(GamesLoadedState(games: games)),
      );
    }
  }

  _onGetGameById(
    GetGameByIdEvent event,
    Emitter<GameState> emit,
  ) async {
    emit(GameLoadingState());

    final result = getGameByIdUseCase.execute(
      uid: event.uid,
    );

    await for (final event in result) {
      event.fold(
        (failure) => emit(GameErrorState(message: failure.message)),
        (game) => emit(GameLoadedState(game: game)),
      );
    }
  }

  void _onCreateGame(
    CreateGameEvent event,
    Emitter<GameState> emit,
  ) async {
    emit(GameLoadingState());

    final result = await createGameUseCase.execute(
      player: event.player,
    );

    result.fold(
      (failure) => emit(GameErrorState(message: failure.message)),
      (game) => emit(GameCreatedState()),
    );
  }

  void _onJoinGame(
    JoinGameEvent event,
    Emitter<GameState> emit,
  ) async {
    emit(GameLoadingState());

    final result = await joinGameUseCase.execute(
      game: event.game,
      player: event.player,
    );

    result.fold(
      (failure) => emit(GameErrorState(message: failure.message)),
      (game) => emit(GameJoinedState()),
    );
  }

  void _onMakeMove(
    MakeMoveEvent event,
    Emitter<GameState> emit,
  ) async {
    emit(GameLoadingState());

    final result = await makeMoveUseCase.execute(
      game: event.game,
      index: event.index,
    );

    result.fold(
      (failure) => emit(GameErrorState(message: failure.message)),
      (game) => emit(GameMoveMadeState()),
    );
  }
}
