import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tictactoe_game/domain/entities/user.dart';
import 'package:tictactoe_game/domain/usecases/auth/get_user.dart';
import 'package:tictactoe_game/domain/usecases/auth/sign_out.dart';

part 'session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  final GetUserUseCase getUserUseCase;
  final SignOutUseCase signOutUseCase;

  SessionCubit({
    required this.getUserUseCase,
    required this.signOutUseCase,
  }) : super(UnknownSessionState());

  void fetchUser() {
    final eitherUserStream = getUserUseCase.execute();

    eitherUserStream.fold(
      (failure) => emit(Unauthenticated()),
      (userStream) {
        userStream.listen(
          (user) => user.isEmpty
              ? emit(Unauthenticated())
              : emit(Authenticated(user: user)),
          onError: (_) => emit(Unauthenticated()),
        );
      },
    );
  }

  Future<void> signOut() async {
    final eitherSignOut = await signOutUseCase.execute();

    eitherSignOut.fold(
      (failure) => emit(Unauthenticated()),
      (_) => emit(Unauthenticated()),
    );
  }
}
