import 'package:dartz/dartz.dart';
import 'package:tictactoe_game/core/error/failure.dart';
import 'package:tictactoe_game/domain/entities/game.dart';
import 'package:tictactoe_game/domain/repositories/game_repository.dart';

class GetGameByIdUseCase {
  final GameRepository gameRepository;

  GetGameByIdUseCase({required this.gameRepository});

  Either<Failure, Stream<GameEntity>> execute({required String uid}) {
    return gameRepository.getGameStreamById(uid: uid);
  }
}
