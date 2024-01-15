import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:tictactoe_game/data/data_sources/auth_data_source.dart';
import 'package:tictactoe_game/data/data_sources/game_data_source.dart';
import 'package:tictactoe_game/data/repositories/auth_repository_impl.dart';
import 'package:tictactoe_game/data/repositories/game_repository_impl.dart';
import 'package:tictactoe_game/domain/repositories/auth_repository.dart';
import 'package:tictactoe_game/domain/repositories/game_repository.dart';
import 'package:tictactoe_game/domain/usecases/auth/get_user.dart';
import 'package:tictactoe_game/domain/usecases/auth/sign_in.dart';
import 'package:tictactoe_game/domain/usecases/auth/sign_out.dart';
import 'package:tictactoe_game/domain/usecases/auth/sign_up.dart';
import 'package:tictactoe_game/domain/usecases/game/create_game.dart';
import 'package:tictactoe_game/domain/usecases/game/get_game_by_id.dart';
import 'package:tictactoe_game/domain/usecases/game/get_games.dart';
import 'package:tictactoe_game/domain/usecases/game/join_game.dart';
import 'package:tictactoe_game/domain/usecases/game/make_move.dart';
import 'package:tictactoe_game/features/auth/logic/auth_bloc/auth_bloc.dart';
import 'package:tictactoe_game/features/game/logic/games_bloc/game_bloc.dart';
import 'package:tictactoe_game/features/auth/logic/session_provider.dart';

final locator = GetIt.instance;

void setupLocator() {
  // bloc
  locator.registerFactory<AuthBloc>(
    () => AuthBloc(
      signInUseCase: locator(),
      signUpUseCase: locator(),
    ),
  );
  locator.registerFactory<GameBloc>(
    () => GameBloc(
      getGamesUseCase: locator(),
      getGameByIdUseCase: locator(),
      createGameUseCase: locator(),
      joinGameUseCase: locator(),
      makeMoveUseCase: locator(),
    ),
  );

  // providers
  locator.registerLazySingleton<SessionProvider>(
    () => SessionProvider(
      authRepository: locator(),
    ),
  );

  // use cases
  locator.registerLazySingleton(
    () => GetUserUseCase(
      authRepository: locator(),
    ),
  );
  locator.registerLazySingleton(
    () => SignInUseCase(
      authRepository: locator(),
    ),
  );
  locator.registerLazySingleton(
    () => SignUpUseCase(
      authRepository: locator(),
    ),
  );
  locator.registerLazySingleton(
    () => SignOutUseCase(
      authRepository: locator(),
    ),
  );
  locator.registerLazySingleton(
    () => GetGamesUseCase(
      gameRepository: locator(),
    ),
  );
  locator.registerLazySingleton(
    () => GetGameByIdUseCase(
      gameRepository: locator(),
    ),
  );
  locator.registerLazySingleton(
    () => CreateGameUseCase(
      gameRepository: locator(),
    ),
  );
  locator.registerLazySingleton(
    () => JoinGameUseCase(
      gameRepository: locator(),
    ),
  );
  locator.registerLazySingleton(
    () => MakeMoveUseCase(
      gameRepository: locator(),
    ),
  );

  // repositories
  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      authDataSource: locator(),
    ),
  );
  locator.registerLazySingleton<GameRepository>(
    () => GameRepositoryImpl(
      gameDataSource: locator(),
    ),
  );

  // data sources
  locator.registerLazySingleton<AuthDataSource>(
    () => AuthDataSourceImpl(
      firebaseAuth: locator(),
      firebaseFirestore: locator(),
    ),
  );
  locator.registerLazySingleton<GameDataSource>(
    () => GameDataSourceImpl(
      firebaseFirestore: locator(),
    ),
  );

  // external
  locator.registerLazySingleton(() => FirebaseAuth.instance);
  locator.registerLazySingleton(() => FirebaseFirestore.instance);
}
