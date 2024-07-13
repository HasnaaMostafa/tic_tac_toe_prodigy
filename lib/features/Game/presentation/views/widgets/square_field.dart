import 'package:flutter/material.dart';

import 'game_engine.dart';

typedef MoveCallback = Future<void> Function(int row, int col);

class SquareField extends StatelessWidget {
  const SquareField({
    super.key,
    required this.uiGame,
    required this.onMove,
  });

  final UiGame uiGame;
  final MoveCallback onMove;

  Widget? markAtSquare(int col, int row) {
    switch (uiGame.markAtSquare(col, row)) {
      case Player.computer:
        return Icon(
          Icons.circle_outlined,
          size: 50,
          color: Colors.grey.shade600,
        );
      case Player.human:
        return Icon(
          Icons.close,
          size: 50,
          color: Colors.grey.shade600,
        );
      case null:
        return null;
    }
  }

  VoidCallback? tapHandler(int col, int row) {
    if (uiGame.currentTurn == Player.human &&
        uiGame.markAtSquare(col, row) == null) {
      return () => onMove(col, row);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int row = 0; row < 3; row++)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int col = 0; col < 3; col++)
                  InkWell(
                    onTap: tapHandler(row, col),
                    child: Container(
                      height: 80,
                      width: 80,
                      color: Colors.white,
                      margin: EdgeInsets.only(
                        top: row == 0 ? 0 : 5,
                        left: col == 0 ? 0 : 5,
                      ),
                      child: Center(
                        child: markAtSquare(row, col),
                      ),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
