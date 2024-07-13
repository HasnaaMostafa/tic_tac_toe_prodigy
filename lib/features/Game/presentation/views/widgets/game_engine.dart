import 'dart:io';
import 'dart:math';

// Interface

abstract class GameEngine {
  factory GameEngine() = _GameEngine;

  Future<UiGame> start();
  Future<UiGame> reportMove(int row, int col);
  Future<UiGame> makeMove();
  void dispose();
}

abstract class UiGame {
  bool get gameOver;
  Player? get winner;
  Player? get currentTurn;
  Player? markAtSquare(int row, int col);
}

enum Player {
  computer,
  human,
}

class _GameEngine implements GameEngine {
  _UiGame _uiGame = _UiGame.start();

  @override
  Future<UiGame> start() async {
    _uiGame = _UiGame.start();
    return _uiGame;
  }

  @override
  Future<UiGame> reportMove(int row, int col) async {
    _uiGame = computeNewState(_UiGame.toSquareIndex(row, col), Player.human);
    return _uiGame;
  }

  @override
  Future<UiGame> makeMove() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _uiGame = computeComputerMove();
    return _uiGame;
  }

  @override
  void dispose() {}

  _UiGame computeNewState(int squareIndex, Player player) {
    assert(_uiGame.currentTurn == player);
    assert(!_uiGame.gameOver);
    assert(_uiGame._squares[squareIndex] == null);

    final List<Player?> squares = [..._uiGame._squares]..[squareIndex] = player;
    final bool didWin = _didWin(player, squares);
    final bool gameOver =
        didWin || squares.every((Player? player) => player != null);

    return _UiGame(
      squares: squares,
      winner: didWin ? player : null,
      gameOver: gameOver,
      currentTurn: gameOver
          ? null
          : (player == Player.computer ? Player.human : Player.computer),
    );
  }

  final Random _random = Random();

  _UiGame computeComputerMove() {
    assert(!_uiGame.gameOver);
    int nextMove;
    do {
      nextMove = _random.nextInt(9);
      sleep(const Duration(seconds: 2));
    } while (_uiGame._squares[nextMove] != null);
    return computeNewState(nextMove, Player.computer);
  }

  bool _didWin(Player player, List<Player?> squares) {
    return (squares[0] == player &&
            squares[1] == player &&
            squares[2] == player) ||
        (squares[3] == player &&
            squares[4] == player &&
            squares[5] == player) ||
        (squares[6] == player &&
            squares[7] == player &&
            squares[8] == player) ||
        (squares[0] == player &&
            squares[4] == player &&
            squares[8] == player) ||
        (squares[2] == player &&
            squares[4] == player &&
            squares[6] == player) ||
        (squares[0] == player &&
            squares[3] == player &&
            squares[6] == player) ||
        (squares[1] == player &&
            squares[4] == player &&
            squares[7] == player) ||
        (squares[2] == player && squares[5] == player && squares[8] == player);
  }
}

class _UiGame implements UiGame {
  _UiGame({
    required List<Player?> squares,
    required this.winner,
    required this.gameOver,
    required this.currentTurn,
  }) : _squares = squares;

  factory _UiGame.start() {
    return _UiGame(
      squares: List.filled(9, null),
      winner: null,
      gameOver: false,
      currentTurn: Player.human,
    );
  }

  final List<Player?> _squares;

  @override
  final Player? winner;
  @override
  final bool gameOver;
  @override
  final Player? currentTurn;

  @override
  Player? markAtSquare(int row, int col) {
    return _squares[toSquareIndex(row, col)];
  }

  static int toSquareIndex(int row, int col) {
    return col + row * 3;
    // convert point to index
  }
}
