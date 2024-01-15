import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tictactoe_game/domain/models/game.dart';

abstract class GameDataSource {
  Stream<List<GameModel>> getGames();
  Stream<GameModel> getGameById({
    required String uid,
  });
  Future<void> createGame({
    required GameModel game,
  });
  Future<void> updateGame({
    required GameModel game,
  });
}

class GameDataSourceImpl extends GameDataSource {
  final FirebaseFirestore firebaseFirestore;
  final CollectionReference<GameModel> _gamesCollection;

  GameDataSourceImpl({
    required this.firebaseFirestore,
  }) : _gamesCollection = firebaseFirestore.collection('games').withConverter(
              fromFirestore: (snapshot, _) =>
                  GameModel.fromJson(snapshot.data()!),
              toFirestore: (game, _) => game.toJson(),
            );

  @override
  Stream<List<GameModel>> getGames() {
    return _gamesCollection.snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) => doc.data()).toList();
      },
    );
  }

  @override
  Stream<GameModel> getGameById({required String uid}) {
    return _gamesCollection.doc(uid).snapshots().map(
          (snapshot) => snapshot.data()!,
        );
  }

  @override
  Future<void> createGame({required GameModel game}) {
    final DocumentReference newGameRef = _gamesCollection.doc();

    return newGameRef.set(
      game.copyWith(uid: newGameRef.id),
    );
  }

  @override
  Future<void> updateGame({required GameModel game}) {
    return _gamesCollection.doc(game.uid).set(game);
  }
}
