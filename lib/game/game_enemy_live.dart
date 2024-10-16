import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:plane/game/game_view.dart';

class GameEnemyLive extends PositionComponent with HasGameRef<GameView> {
  final Vector2 s;
  final Vector2 pos;
  final int live;

  int liveNow = 0;

  double liveWidth = 0;

  GameEnemyLive({required this.s, required this.live, required this.pos});

  @override
  Future<void> onLoad() async {
    size = s;
    position = pos;
    liveNow = live;
    liveWidth = s.x / live;

    priority = 10;

    return super.onLoad();
  }

  void updateLive(int live) {
    liveNow = live;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    canvas.save();
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.x, size.y),
        Paint()
          ..color = Colors.green
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2);

    canvas.drawRect(
        Rect.fromLTWH(0, 0, liveWidth * liveNow, size.y),
        Paint()
          ..color = Colors.red
          ..style = PaintingStyle.fill);

    canvas.restore();
  }
}
