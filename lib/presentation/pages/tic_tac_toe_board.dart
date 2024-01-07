import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe_game/models/game_model.dart';
import 'package:tictactoe_game/models/user_model.dart';
import 'package:tictactoe_game/services/game_service.dart';

class TicTacToeBoard extends StatefulWidget {
  final String gameUid;

  const TicTacToeBoard({
    super.key,
    required this.gameUid,
  });

  @override
  State<TicTacToeBoard> createState() => _TicTacToeBoardState();
}

class _TicTacToeBoardState extends State<TicTacToeBoard> {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    final GameService gameService = Provider.of<GameService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tic Tac Toe"),
        centerTitle: true,
      ),
      body: StreamBuilder<Game>(
        stream: gameService.getGameStream(widget.gameUid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Game game = snapshot.data!;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20.0),
                Text(
                  game.currentTurn == user.uid
                      ? "Your Turn"
                      : "Opponent's Turn",
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20.0),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemCount: 9,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          if (game.board[index].isEmpty &&
                              game.currentTurn == user.uid) {
                            gameService.makeMove(
                              game: game,
                              index: index,
                            );
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(10.0),
                            color: game.board[index].isEmpty
                                ? Colors.blueAccent
                                : Colors.grey[300],
                          ),
                          margin: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              game.board[index],
                              style: TextStyle(
                                fontSize: 24.0,
                                color: game.board[index].isEmpty
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20.0),
                // Winner Display
                game.winner != null
                    ? Text(
                        game.winner == user.uid ? "You Win!" : "Opponent Wins!",
                        style: const TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      )
                    : Container(),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
