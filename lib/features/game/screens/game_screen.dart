import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tictactoe_game/domain/models/game.dart';
import 'package:tictactoe_game/features/game/logic/games_bloc/game_bloc.dart';
import 'package:tictactoe_game/features/auth/logic/session_provider.dart';

class GameScreen extends StatefulWidget {
  static const routeName = '/board';

  final String gameUid;

  const GameScreen({
    super.key,
    required this.gameUid,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  Widget _buildWidget = const Center(
    child: CircularProgressIndicator(),
  );

  @override
  void initState() {
    context.read<GameBloc>().add(GetGameByIdEvent(uid: widget.gameUid));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<SessionProvider>().user;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tic Tac Toe"),
        centerTitle: true,
      ),
      body: BlocBuilder<GameBloc, GameState>(
        builder: (context, state) {
          if (state is GameLoadedState) {
            GameModel game = state.game;

            _buildWidget = IgnorePointer(
              ignoring: game.status != GameStatus.playing,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20.0),
                  game.status == GameStatus.playing
                      ? Text(
                          game.currentTurn == user.uid
                              ? "Your Turn"
                              : "Opponent's Turn",
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        )
                      : const SizedBox.shrink(),
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
                              context.read<GameBloc>().add(
                                    MakeMoveEvent(
                                      game: game,
                                      index: index,
                                    ),
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
                  game.status == GameStatus.finished
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 50.0),
                          child: Text(
                            game.winner == user.uid
                                ? "You Won!"
                                : game.winner == null
                                    ? "It's a Draw!"
                                    : "You Lost!",
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: game.winner == user.uid
                                  ? Colors.green
                                  : game.winner == null
                                      ? Colors.grey
                                      : Colors.red,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            );
          }
          return _buildWidget;
        },
      ),
    );
  }
}
