import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe_game/models/game_model.dart';
import 'package:tictactoe_game/models/user_model.dart';
import 'package:tictactoe_game/presentation/pages/tic_tac_toe_board.dart';
import 'package:tictactoe_game/services/auth_service.dart';
import 'package:tictactoe_game/services/game_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    final AuthService authService = Provider.of<AuthService>(context);
    final GameService gameService = Provider.of<GameService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
        actions: [
          IconButton(
            onPressed: () async {
              await authService.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder<List<Game>>(
        stream: gameService.getGamesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Game> games = snapshot.data!;
            return ListView.builder(
              itemCount: games.length,
              itemBuilder: (context, index) {
                final Game game = games[index];

                return ListTile(
                  title: Text('Game ${game.uid}'),
                  subtitle: Text('Status: ${game.status.name}'),
                  onTap: () async {
                    if (game.status == GameStatus.waiting &&
                        game.players[0]!.uid != user.uid) {
                      await gameService
                          .joinGame(
                            game: games[index],
                            player: user,
                          )
                          .then(
                            (_) => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TicTacToeBoard(
                                  gameUid: games[index].uid,
                                ),
                              ),
                            ),
                          );
                    } else if (game.status == GameStatus.playing &&
                        game.players
                            .any((element) => element!.uid == user.uid)) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TicTacToeBoard(
                            gameUid: games[index].uid,
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await gameService.createGame(player: user);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
