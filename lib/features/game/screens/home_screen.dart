import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tictactoe_game/domain/models/game.dart';
import 'package:tictactoe_game/domain/models/user.dart';
import 'package:tictactoe_game/features/game/logic/games_bloc/game_bloc.dart';
import 'package:tictactoe_game/features/auth/logic/session_provider.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget _buildWidget = const Center(
    child: CircularProgressIndicator(),
  );

  @override
  void initState() {
    context.read<GameBloc>().add(const GetGamesListEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<SessionProvider>().user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              context.read<SessionProvider>().signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: BlocConsumer<GameBloc, GameState>(
        listener: (context, state) {
          if (state is GameErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is GamesLoadedState) {
            _buildWidget = _buildGamesList(state.games, user);
          } else if (state is GameLoadingState) {
            _buildWidget = const Center(
              child: CircularProgressIndicator(),
            );
          }
          return _buildWidget;
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<GameBloc>().add(
                CreateGameEvent(
                  player: user,
                ),
              );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildGamesList(List<GameModel> games, UserModel user) {
    return ListView.builder(
      itemCount: games.length,
      itemBuilder: (context, index) {
        final game = games[index];
        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
          child: ListTile(
            title: Text(
              '${game.firstPlayer!.email} vs ${game.secondPlayer?.email ?? 'Waiting...'}',
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
            tileColor:
                game.status == GameStatus.playing ? Colors.yellow[100] : null,
            onTap: () async {
              if (game.status == GameStatus.waiting &&
                  game.firstPlayer!.uid != user.uid) {
                context.read<GameBloc>().add(
                      JoinGameEvent(
                        game: game,
                        player: user,
                      ),
                    );
              } else if ((game.status == GameStatus.playing ||
                      game.status == GameStatus.finished) &&
                  (game.firstPlayer!.uid == user.uid ||
                      game.secondPlayer!.uid == user.uid)) {
                context.go('/home/game/${game.uid}');
              }
            },
          ),
        );
      },
    );
  }
}
