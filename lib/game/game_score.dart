import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:plane/game/game_controller.dart';
import 'package:plane/game/game_view.dart';

class GameScore extends PositionComponent with HasGameRef<GameView> {
  late SpriteSheet numbers;

  @override
  Future<void> onLoad() async {
    numbers = SpriteSheet.fromColumnsAndRows(
        image: await Flame.images.load("ui/ranking-num02.png"),
        columns: 10,
        rows: 1);

    size = Vector2(game.size.x / 2, 20.w);

    position = Vector2(
        game.size.x / 2,
        (kToolbarHeight - 20.w) / 2 +
            MediaQuery.of(GameController().getContent()).padding.top);

    updateScore();

    priority = 998;

    return super.onLoad();
  }

  void updateScore() {
    final temp = "${GameController().score}".split("");
    final text = <SpriteComponent>[];
    for (int i = 0; i < temp.length; i++) {
      text.add(SpriteComponent(
          sprite: numbers.getSprite(0, int.parse(temp[i])),
          size: Vector2(20.w, 20.w),
          position: Vector2(position.x - (temp.length - i) * 25.w, 0)));
    }

    removeAll(children);
    addAll(text);
  }
}
