import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tictactoe_game/models/game_model.dart';
import 'package:tictactoe_game/models/user_model.dart';

class GameService {
  final CollectionReference<Game> _gamesCollection = FirebaseFirestore.instance
      .collection('games')
      .withConverter(
        fromFirestore: (snapshot, _) => Game.fromFirestore(snapshot.data()!),
        toFirestore: (game, _) => game.toFirestore(),
      );

  Stream<List<Game>> getGamesStream() {
    return _gamesCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Stream<Game> getGameStream(String uid) {
    return _gamesCollection.doc(uid).snapshots().map((snapshot) {
      return snapshot.data()!;
    });
  }

  Future<void> createGame({
    required User player,
  }) async {
    final DocumentReference newGameRef = _gamesCollection.doc();
    final Game newGame = Game(
      uid: newGameRef.id,
      players: [
        player,
        User.empty(),
      ],
      currentTurn: null,
      winner: null,
      status: GameStatus.waiting,
      board: List.generate(9, (index) => ''),
    );

    await newGameRef.set(newGame);
  }

  Future<void> joinGame({
    required Game game,
    required User player,
  }) async {
    final Game updatedGame = game.copyWith(
      players: [
        game.players[0],
        player,
      ],
      currentTurn: game.players[0]!.uid,
      status: GameStatus.playing,
    );
    await _gamesCollection.doc(game.uid).set(updatedGame);
  }

  Future<void> makeMove({
    required Game game,
    required int index,
  }) async {
    final Game updatedGame = game.copyWith(
      currentTurn: game.players[0]!.uid == game.currentTurn
          ? game.players[1]!.uid
          : game.players[0]!.uid,
      board: List.generate(9, (i) {
        if (i == index) {
          return game.players[0]!.uid == game.currentTurn ? 'X' : 'O';
        } else {
          return game.board[i];
        }
      }),
    );
    await _gamesCollection.doc(game.uid).set(updatedGame);
  }

  Future<void> endGame({
    required Game game,
    required String winnerUid,
  }) async {
    final Game updatedGame = game.copyWith(
      winner: winnerUid,
      status: GameStatus.finished,
    );
    await _gamesCollection.doc(game.uid).set(updatedGame);
  }
}
