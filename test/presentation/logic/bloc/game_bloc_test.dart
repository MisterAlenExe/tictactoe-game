import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictactoe_game/core/error/failure.dart';
import 'package:tictactoe_game/domain/models/game.dart';
import 'package:tictactoe_game/domain/models/user.dart';
import 'package:tictactoe_game/features/game/logic/games_bloc/game_bloc.dart';

import '../../../utils/mocks/mocks.dart';

void main() {
  late MockGetGamesUseCase mockGetGamesUseCase;
  late MockGetGameByIdUseCase mockGetGameByIdUseCase;
  late MockCreateGameUseCase mockCreateGameUseCase;
  late MockJoinGameUseCase mockJoinGameUseCase;
  late MockMakeMoveUseCase mockMakeMoveUseCase;

  late GameBloc gameBloc;

  setUp(() {
    mockGetGamesUseCase = MockGetGamesUseCase();
    mockGetGameByIdUseCase = MockGetGameByIdUseCase();
    mockCreateGameUseCase = MockCreateGameUseCase();
    mockJoinGameUseCase = MockJoinGameUseCase();
    mockMakeMoveUseCase = MockMakeMoveUseCase();

    gameBloc = GameBloc(
      getGamesUseCase: mockGetGamesUseCase,
      getGameByIdUseCase: mockGetGameByIdUseCase,
      createGameUseCase: mockCreateGameUseCase,
      joinGameUseCase: mockJoinGameUseCase,
      makeMoveUseCase: mockMakeMoveUseCase,
    );
  });

  final gameModel = GameModel(
    uid: 'test-uid',
    firstPlayer: const UserModel(
      uid: 'test-uid',
      email: 'test-email',
    ),
    secondPlayer: const UserModel.empty(),
    currentTurn: null,
    winner: null,
    status: GameStatus.waiting,
    board: List.generate(9, (index) => ''),
  );

  final gamesList = List.generate(
    3,
    (index) => GameModel(
      uid: 'test-uid-$index',
      firstPlayer: const UserModel(
        uid: 'test-uid',
        email: 'test-email',
      ),
      secondPlayer: const UserModel.empty(),
      currentTurn: null,
      winner: null,
      status: GameStatus.waiting,
      board: List.generate(9, (index) => ''),
    ),
  );

  test(
    'Initial state should be GameInitial',
    () {
      expect(gameBloc.state, equals(GameStateInitial()));
    },
  );

  group(
    'GetGamesList event',
    () {
      blocTest<GameBloc, GameState>(
        'emits [GameLoading, GamesLoaded] when GetGamesListEvent is added',
        build: () {
          when(() => mockGetGamesUseCase.execute()).thenAnswer(
            (_) => Stream.value(
              Right(gamesList),
            ),
          );
          return gameBloc;
        },
        act: (bloc) => bloc.add(
          const GetGamesListEvent(),
        ),
        wait: const Duration(milliseconds: 500),
        expect: () => <GameState>[
          GameLoadingState(),
          GamesLoadedState(games: gamesList),
        ],
      );

      blocTest<GameBloc, GameState>(
        'emits [GameLoading, GameError] when GetGamesListEvent is added and fails',
        build: () {
          when(() => mockGetGamesUseCase.execute()).thenAnswer(
            (_) => Stream.value(
              const Left(
                FirestoreFailure(message: 'test-error'),
              ),
            ),
          );
          return gameBloc;
        },
        act: (bloc) => bloc.add(
          const GetGamesListEvent(),
        ),
        wait: const Duration(milliseconds: 500),
        expect: () => <GameState>[
          GameLoadingState(),
          GameErrorState(message: 'test-error'),
        ],
      );
    },
  );

  group(
    'GetGameById event',
    () {
      blocTest<GameBloc, GameState>(
        'emits [GameLoading, GameLoaded] when GetGameByIdEvent is added',
        build: () {
          when(() => mockGetGameByIdUseCase.execute(uid: 'test-uid'))
              .thenAnswer(
            (_) => Stream.value(
              Right(gameModel),
            ),
          );
          return gameBloc;
        },
        act: (bloc) => bloc.add(
          const GetGameByIdEvent(uid: 'test-uid'),
        ),
        wait: const Duration(milliseconds: 500),
        expect: () => <GameState>[
          GameLoadingState(),
          GameLoadedState(game: gameModel),
        ],
      );

      blocTest<GameBloc, GameState>(
        'emits [GameLoading, GameError] when GetGameByIdEvent is added and fails',
        build: () {
          when(() => mockGetGameByIdUseCase.execute(uid: 'test-uid'))
              .thenAnswer(
            (_) => Stream.value(
              const Left(
                FirestoreFailure(message: 'test-error'),
              ),
            ),
          );
          return gameBloc;
        },
        act: (bloc) => bloc.add(
          const GetGameByIdEvent(uid: 'test-uid'),
        ),
        wait: const Duration(milliseconds: 500),
        expect: () => <GameState>[
          GameLoadingState(),
          GameErrorState(message: 'test-error'),
        ],
      );
    },
  );

  group(
    'CreateGame event',
    () {
      blocTest<GameBloc, GameState>(
        'emits [GameLoading, GameCreated] when CreateGameEvent is added',
        build: () {
          when(
            () => mockCreateGameUseCase.execute(
              player: const UserModel(
                uid: 'test-uid',
                email: 'test-email',
              ),
            ),
          ).thenAnswer(
            (_) => Future.value(
              const Right(null),
            ),
          );
          return gameBloc;
        },
        act: (bloc) => bloc.add(
          const CreateGameEvent(
            player: UserModel(
              uid: 'test-uid',
              email: 'test-email',
            ),
          ),
        ),
        wait: const Duration(milliseconds: 500),
        expect: () => <GameState>[
          GameLoadingState(),
          GameCreatedState(),
        ],
      );

      blocTest<GameBloc, GameState>(
        'emits [GameLoading, GameError] when CreateGameEvent is added and fails',
        build: () {
          when(
            () => mockCreateGameUseCase.execute(
              player: const UserModel(
                uid: 'test-uid',
                email: 'test-email',
              ),
            ),
          ).thenAnswer(
            (_) => Future.value(
              const Left(
                FirestoreFailure(message: 'test-error'),
              ),
            ),
          );
          return gameBloc;
        },
        act: (bloc) => bloc.add(
          const CreateGameEvent(
            player: UserModel(
              uid: 'test-uid',
              email: 'test-email',
            ),
          ),
        ),
        wait: const Duration(milliseconds: 500),
        expect: () => <GameState>[
          GameLoadingState(),
          GameErrorState(message: 'test-error'),
        ],
      );
    },
  );

  group(
    'JoinGame event',
    () {
      blocTest<GameBloc, GameState>(
        'emits [GameLoading, GameJoined] when JoinGameEvent is added',
        build: () {
          when(
            () => mockJoinGameUseCase.execute(
              game: gameModel,
              player: const UserModel(
                uid: 'test-uid',
                email: 'test-email',
              ),
            ),
          ).thenAnswer(
            (_) => Future.value(
              const Right(null),
            ),
          );
          return gameBloc;
        },
        act: (bloc) => bloc.add(
          JoinGameEvent(
            game: gameModel,
            player: const UserModel(
              uid: 'test-uid',
              email: 'test-email',
            ),
          ),
        ),
        wait: const Duration(milliseconds: 500),
        expect: () => <GameState>[
          GameLoadingState(),
          GameJoinedState(),
        ],
      );

      blocTest<GameBloc, GameState>(
        'emits [GameLoading, GameError] when JoinGameEvent is added and fails',
        build: () {
          when(
            () => mockJoinGameUseCase.execute(
              game: gameModel,
              player: const UserModel(
                uid: 'test-uid',
                email: 'test-email',
              ),
            ),
          ).thenAnswer(
            (_) => Future.value(
              const Left(
                FirestoreFailure(message: 'test-error'),
              ),
            ),
          );
          return gameBloc;
        },
        act: (bloc) => bloc.add(
          JoinGameEvent(
            game: gameModel,
            player: const UserModel(
              uid: 'test-uid',
              email: 'test-email',
            ),
          ),
        ),
        wait: const Duration(milliseconds: 500),
        expect: () => <GameState>[
          GameLoadingState(),
          GameErrorState(message: 'test-error'),
        ],
      );
    },
  );

  group(
    'MakeMove event',
    () {
      blocTest<GameBloc, GameState>(
        'emits [GameLoading, GameMoveMade] when MakeMoveEvent is added',
        build: () {
          when(
            () => mockMakeMoveUseCase.execute(
              game: gameModel,
              index: 0,
            ),
          ).thenAnswer(
            (_) => Future.value(
              const Right(null),
            ),
          );
          return gameBloc;
        },
        act: (bloc) => bloc.add(
          MakeMoveEvent(
            game: gameModel,
            index: 0,
          ),
        ),
        wait: const Duration(milliseconds: 500),
        expect: () => <GameState>[
          GameLoadingState(),
          GameMoveMadeState(),
        ],
      );

      blocTest<GameBloc, GameState>(
        'emits [GameLoading, GameError] when MakeMoveEvent is added and fails',
        build: () {
          when(
            () => mockMakeMoveUseCase.execute(
              game: gameModel,
              index: 0,
            ),
          ).thenAnswer(
            (_) => Future.value(
              const Left(
                FirestoreFailure(message: 'test-error'),
              ),
            ),
          );
          return gameBloc;
        },
        act: (bloc) => bloc.add(
          MakeMoveEvent(
            game: gameModel,
            index: 0,
          ),
        ),
        wait: const Duration(milliseconds: 500),
        expect: () => <GameState>[
          GameLoadingState(),
          GameErrorState(message: 'test-error'),
        ],
      );
    },
  );
}
