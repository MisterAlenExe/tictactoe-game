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
    List<String> boardData = List.generate(9, (i) {
      if (i == index) {
        return game.players[0]!.uid == game.currentTurn ? 'X' : 'O';
      } else {
        return game.board[i];
      }
    });
    final Game updatedGame = game.copyWith(
      currentTurn: game.players[0]!.uid == game.currentTurn
          ? game.players[1]!.uid
          : game.players[0]!.uid,
      board: boardData,
    );

    await _gamesCollection.doc(game.uid).set(updatedGame);

    bool winner = checkWinner(boardData);
    if (winner) {
      await endGame(game: updatedGame, winnerUid: game.currentTurn!);
      return;
    }

    bool draw = !boardData.contains('');
    if (draw) {
      await endGame(game: updatedGame, winnerUid: '');
      return;
    }
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

  bool checkWinner(List<String> board) {
    final List<List<int>> winningConditions = [
      [0, 1, 2], // row 1
      [3, 4, 5], // row 2
      [6, 7, 8], // row 3
      [0, 3, 6], // column 1
      [1, 4, 7], // column 2
      [2, 5, 8], // column 3
      [0, 4, 8], // diagonal 1
      [2, 4, 6], // diagonal 2
    ];

    for (final condition in winningConditions) {
      if (board[condition[0]] != '' &&
          board[condition[0]] == board[condition[1]] &&
          board[condition[1]] == board[condition[2]]) {
        return true;
      }
    }

    return false;
  }
}
