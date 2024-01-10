import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:tictactoe_game/data/data_sources/auth_data_source.dart';
import 'package:tictactoe_game/data/repositories/auth_repository_impl.dart';
import 'package:tictactoe_game/domain/repositories/auth_repository.dart';
import 'package:tictactoe_game/domain/usecases/auth/get_user.dart';
import 'package:tictactoe_game/domain/usecases/auth/sign_in.dart';
import 'package:tictactoe_game/domain/usecases/auth/sign_out.dart';
import 'package:tictactoe_game/domain/usecases/auth/sign_up.dart';
import 'package:tictactoe_game/features/auth/logic/auth_bloc/auth_bloc.dart';
import 'package:tictactoe_game/features/auth/logic/session_cubit/session_cubit.dart';

final locator = GetIt.instance;

void setupLocator() {
  // bloc
  locator.registerFactory<AuthBloc>(
    () => AuthBloc(
      signInUseCase: locator(),
      signUpUseCase: locator(),
    ),
  );

  // cubit
  locator.registerFactory<SessionCubit>(
    () => SessionCubit(
      getUserUseCase: locator(),
      signOutUseCase: locator(),
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

  // repositories
  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      authDataSource: locator(),
    ),
  );

  // data sources
  locator.registerLazySingleton<AuthDataSource>(
    () => AuthDataSourceImpl(
      firebaseAuth: locator(),
      firebaseFirestore: locator(),
    ),
  );

  // external
  locator.registerLazySingleton(() => FirebaseAuth.instance);
  locator.registerLazySingleton(() => FirebaseFirestore.instance);
}
