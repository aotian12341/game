import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:plane/game/game_controller.dart';
import 'package:plane/game/game_dialog.dart';
import 'package:plane/game/game_sprite_btn.dart';
import 'package:plane/game/game_view.dart';

class GameStateBtn extends PositionComponent with HasGameRef<GameView> {
  @override
  Future<void> onLoad() async {
    final back = await Flame.images.load("ui/btn_back.png");
    final stop = await Flame.images.load("ui/btn_stop.png");

    position =
        Vector2(0, MediaQuery.of(GameController().getContent()).padding.top);

    final btnWidth = 40.w, btnHeight = 30.w;
    const allHeight = kToolbarHeight;

    final backBtn = SpriteBtn(
        pos: Vector2(10.w, (allHeight - btnHeight) / 2),
        s: Vector2(btnWidth, btnHeight),
        img: Sprite(back),
        onClick: () {
          Navigator.pop(GameController().getContent());
          GameController().stopGame();
        });

    final stopBtn = SpriteBtn(
        pos: Vector2(80.w, (allHeight - btnHeight) / 2),
        s: Vector2(btnWidth / 2, btnHeight),
        img: Sprite(stop),
        onClick: () {
          GameController().isRunning = false;
          game.add(GameDialog(onBack: () {}, type: 1));
        });

    addAll([backBtn]);

    priority = 998;

    return super.onLoad();
  }
}
