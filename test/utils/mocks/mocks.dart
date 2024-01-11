import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictactoe_game/data/data_sources/auth_data_source.dart';
import 'package:tictactoe_game/domain/repositories/auth_repository.dart';
import 'package:tictactoe_game/domain/usecases/auth/get_user.dart';
import 'package:tictactoe_game/domain/usecases/auth/sign_in.dart';
import 'package:tictactoe_game/domain/usecases/auth/sign_out.dart';
import 'package:tictactoe_game/domain/usecases/auth/sign_up.dart';
import 'package:tictactoe_game/features/auth/logic/auth_bloc/auth_bloc.dart';
import 'package:tictactoe_game/features/auth/logic/session_cubit/session_cubit.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

class MockSessionCubit extends MockCubit<SessionState>
    implements SessionCubit {}

class MockGetUserUseCase extends Mock implements GetUserUseCase {}

class MockSignOutUseCase extends Mock implements SignOutUseCase {}

class MockSignInUseCase extends Mock implements SignInUseCase {}

class MockSignUpUseCase extends Mock implements SignUpUseCase {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockAuthDataSource extends Mock implements AuthDataSource {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockFirebaseUser extends Mock implements User {}

class MockFirebaseUserCredential extends Mock implements UserCredential {}