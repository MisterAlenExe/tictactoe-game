import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe_game/data/data_sources/game_data_source.dart';
import 'package:tictactoe_game/domain/models/game.dart';
import 'package:tictactoe_game/domain/models/user.dart';

void main() {
  late GameDataSourceImpl gameDataSourceImpl;
  late CollectionReference<GameModel> gamesCollection;

  final gamesList = List.generate(
    5,
    (index) => GameModel(
      uid: "uid-$index",
      firstPlayer: UserModel(
        uid: "uid-player-1-$index",
        email: "email-player-1-$index",
      ),
      secondPlayer: const UserModel.empty(),
      currentTurn: null,
      winner: null,
      status: GameStatus.waiting,
      board: List.generate(9, (index) => ''),
    ),
  );

  setDummyFirestore(CollectionReference<GameModel> gamesCollection) async {
    for (var game in gamesList) {
      gamesCollection.doc(game.uid).set(game);
    }
  }

  setUp(() {
    FakeFirebaseFirestore firestore = FakeFirebaseFirestore();

    gameDataSourceImpl = GameDataSourceImpl(
      firebaseFirestore: firestore,
    );

    gamesCollection = firestore.collection('games').withConverter(
          fromFirestore: (snapshot, _) => GameModel.fromJson(snapshot.data()!),
          toFirestore: (game, _) => game.toJson(),
        );

    setDummyFirestore(gamesCollection);
  });

  group(
    "gameDataSource",
    () {
      test(
        "should return a list of games when the getGames is successful",
        () async {
          // arrange
          // act
          final result = gameDataSourceImpl.getGames();

          // assert
          expect(
            result,
            emitsInOrder(
              [
                gamesList,
              ],
            ),
          );
        },
      );

      test(
        "should return a game when the getGameById is successful",
        () async {
          // arrange
          // act
          final result = gameDataSourceImpl.getGameById(uid: "uid-2");

          // assert
          expect(
            result,
            emitsInOrder(
              [
                gamesList[2],
              ],
            ),
          );
        },
      );

      test(
        "should create a game when the createGame is successful",
        () async {
          // arrange
          GameModel expectedGame = GameModel(
            uid: "uid-6",
            firstPlayer: const UserModel(
              uid: "uid-player-1-6",
              email: "email-player-1-6",
            ),
            secondPlayer: const UserModel.empty(),
            currentTurn: null,
            winner: null,
            status: GameStatus.waiting,
            board: List.generate(9, (index) => ''),
          );

          // act
          await gameDataSourceImpl.createGame(game: expectedGame);

          // assert
          GameModel? actualGame = await gamesCollection
              .where(
                'firstPlayer.uid',
                isEqualTo: "uid-player-1-6",
              )
              .get()
              .then((value) => value.docs[0].data());
          expectedGame = expectedGame.copyWith(uid: actualGame!.uid);
          expect(actualGame, expectedGame);
        },
      );

      test(
        "should update a game when the updateGame is successful",
        () async {
          // arrange
          final expectedData = GameModel(
            uid: "uid-2",
            firstPlayer: const UserModel(
              uid: "uid-player-1-2",
              email: "email-player-1-2",
            ),
            secondPlayer: const UserModel(
              uid: "uid-player-2-2",
              email: "email-player-2-2",
            ),
            currentTurn: "uid-player-1-2",
            winner: 'uid-player-1-2',
            status: GameStatus.finished,
            board: List.generate(9, (index) => 'X'),
          );

          // act
          await gameDataSourceImpl.updateGame(game: expectedData);

          // assert
          GameModel? firestoreData = await gamesCollection
              .doc("uid-2")
              .get()
              .then((value) => value.data());

          expect(firestoreData, expectedData);
        },
      );
    },
  );
}
