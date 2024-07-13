import 'package:flutter/material.dart';

import 'game_engine.dart';

typedef StartGameCallback = void Function(GameEngine engine);

class Lobby extends StatelessWidget {
  const Lobby({super.key, required this.onStartGame});

  final StartGameCallback onStartGame;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 160, 20, 0),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all<Color>(Colors.white)),
              child: const Text(
                'Start',
                style: TextStyle(color: Color(0xffff8dcb), fontSize: 25),
              ),
              onPressed: () {
                onStartGame(GameEngine());
              },
            ),
          ),
        ),
      ],
    );
  }
}
