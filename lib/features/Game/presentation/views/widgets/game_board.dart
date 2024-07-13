import 'package:flutter/material.dart';

import 'game_engine.dart';
import 'square_field.dart';

class GameBoard extends StatelessWidget {
  const GameBoard({
    super.key,
    required this.uiGame,
    required this.onMove,
  });

  final UiGame uiGame;
  final MoveCallback onMove;

  String get gameStatusMessage {
    switch (uiGame.currentTurn) {
      case Player.computer:
        return 'Computer is thinking...';
      case Player.human:
        return 'Computer is waiting for your move!';
      case null:
        switch (uiGame.winner) {
          case Player.computer:
            return 'Game Over! Computer won.';
          case Player.human:
            return 'Congratulations! You won.';
          case null:
            return "Game Over! It's a tie!";
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(40),
          child: SquareField(
            uiGame: uiGame,
            onMove: onMove,
          ),
        ),
        Center(
          child: Text(
            gameStatusMessage,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        )
      ],
    );
  }
}
