import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import 'game_board.dart';
import 'game_engine.dart';
import 'lobby.dart';

class TicTacToeGameBody extends StatefulWidget {
  const TicTacToeGameBody({super.key});

  @override
  State<TicTacToeGameBody> createState() => _TicTacToeGameBodyState();
}

class _TicTacToeGameBodyState extends State<TicTacToeGameBody> {
  GameEngine? _engine;
  UiGame? uiGame;

  final ConfettiController controller = ConfettiController(
    duration: const Duration(seconds: 7),
  );

  Future<void> startGame(GameEngine engine) async {
    setState(() {
      _engine = engine;
    });
    final UiGame state = await _engine!.start();
    setState(() {
      uiGame = state;
    });
  }

  Future<void> reportMove(int row, int col) async {
    UiGame state = await _engine!.reportMove(row, col);
    setState(() {
      uiGame = state;
    });
    if (!state.gameOver) {
      state = await _engine!.makeMove();
      setState(() {
        uiGame = state;
      });
    } else if (state.winner == Player.human) {
      controller.play();
    }
  }

  void reset() {
    setState(() {
      _engine?.dispose();
      _engine = null;
      uiGame = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConfettiWidget(
      confettiController: controller,
      blastDirectionality: BlastDirectionality.explosive,
      maxBlastForce: 100,
      emissionFrequency: 0.05,
      numberOfParticles: 25,
      gravity: 1,
      child: Scaffold(
        backgroundColor: const Color(0xffff8dcb),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: const Text(
            'Tic Tac Toe',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              onPressed: reset,
              icon: const Icon(
                Icons.restart_alt,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            const Image(image: AssetImage("assets/images/xo.jpg")),
            SizedBox(
              width: 340,
              child: Center(
                child: _engine == null
                    ? Lobby(onStartGame: startGame)
                    : uiGame != null
                        ? GameBoard(uiGame: uiGame!, onMove: reportMove)
                        : const Text('Loading...'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
