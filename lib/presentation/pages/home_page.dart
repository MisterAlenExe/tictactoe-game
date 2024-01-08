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
        centerTitle: true,
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
            games.sort((a, b) => a.status.index.compareTo(b.status.index));
            return ListView.builder(
              itemCount: games.length,
              itemBuilder: (context, index) {
                final Game game = games[index];

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                  child: ListTile(
                    title: Text(
                      '${game.players[0]!.email}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Status: ${game.status.name.toUpperCase()}',
                      style: TextStyle(
                        fontSize: 14,
                        color: game.status == GameStatus.waiting
                            ? Colors.green
                            : game.status == GameStatus.playing
                                ? Colors.blue
                                : Colors.grey,
                      ),
                    ),
                    tileColor: game.status == GameStatus.playing
                        ? Colors.yellow[100]
                        : null,
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
                      } else if ((game.status == GameStatus.playing ||
                              game.status == GameStatus.finished) &&
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
                  ),
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
