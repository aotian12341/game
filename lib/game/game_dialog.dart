import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:plane/game/game_controller.dart';
import 'package:plane/game/game_sprite_btn.dart';
import 'package:plane/game/game_view.dart';

class GameDialog extends PositionComponent with HasGameRef<GameView> {
  GameDialog({required this.onBack, required this.type});

  final Function onBack;

  final int type;

  bool close = false;

  late Vector2 bgSize, bgPos;

  int action = 0;

  @override
  Future<void> onLoad() async {
    final width = game.size.x * 0.8;
    final height = width * 148 / 356;
    final x = (game.size.x - width) / 2;
    final y = (game.size.y - height) / 2;

    bgSize = Vector2(width, height);
    size = game.size;
    position = Vector2(0, 0);
    bgPos = Vector2((size.x - width) / 2, (size.y - height) / 2);

    final bg = await Flame.images.load("ui/framebottom002.png");
    final sprite = Sprite(bg);
    add(SpriteComponent(
        sprite: Sprite(await Flame.images.load("ui/mask.png")),
        size: game.size));
    add(SpriteComponent(sprite: sprite, size: bgSize, position: bgPos));

    if (type == 0) {
      initStart();
    } else if (type == 1) {
      initStop();
    } else if (type == 2) {
      initScore();
    }

    priority = 99999;

    return super.onLoad();
  }

  void initScore() async {
    final btnWidth = bgSize.x / 3;
    final btnHeight = btnWidth * 62 / 209;
    final leftPos = Vector2(bgPos.x + bgSize.x / 3 - btnWidth / 2 - 10.w,
        bgPos.y + bgSize.y - btnHeight * 1.5);
    final rightPos = Vector2(bgPos.x + bgSize.x * 2 / 3 - btnWidth / 2 + 10.w,
        bgPos.y + bgSize.y - btnHeight * 1.5);
    final btnLeft = SpriteBtn(
        pos: leftPos,
        s: Vector2(btnWidth, btnHeight),
        img: Sprite(await Flame.images.load("ui/btn_orange.png")),
        onClick: () {
          goOn();
        });
    final btnRight = SpriteBtn(
        pos: rightPos,
        s: Vector2(btnWidth, btnHeight),
        img: Sprite(await Flame.images.load("ui/btn_blue.png")),
        onClick: () {
          Navigator.pop(GameController().getContent());
          GameController().stopGame();
        });
    add(btnLeft);
    add(btnRight);

    add(TextComponent(
        text: "积分不足",
        position: Vector2(
            bgPos.x + bgSize.x / 2, bgPos.y + (bgSize.y - btnHeight * 1.5) / 2),
        anchor: Anchor.center));
  }

  void initStart() async {
    final btnWidth = bgSize.x / 2;
    final btnHeight = btnWidth * 66 / 262;

    final start = SpriteBtn(
        pos: Vector2(bgPos.x + (bgSize.x - btnWidth) / 2,
            bgPos.y + (bgSize.y - btnHeight) / 2),
        s: Vector2(btnWidth, btnHeight),
        img: Sprite(await Flame.images.load("ui/btn_start.png")),
        onClick: () {
          action = 0;
          closeDialog();
        });

    add(start);
  }

  void initStop() async {
    final btnWidth = bgSize.x / 3;
    final btnHeight = btnWidth * 62 / 209;
    final leftPos = Vector2(bgPos.x + bgSize.x / 3 - btnWidth / 2 - 10.w,
        bgPos.y + bgSize.y - btnHeight * 1.5);
    final rightPos = Vector2(bgPos.x + bgSize.x * 2 / 3 - btnWidth / 2 + 10.w,
        bgPos.y + bgSize.y - btnHeight * 1.5);
    final btnLeft = SpriteBtn(
        pos: leftPos,
        s: Vector2(btnWidth, btnHeight),
        img: Sprite(await Flame.images.load("ui/btn_yellow.png")),
        onClick: () {
          goOn();
        });
    final btnRight = SpriteBtn(
        pos: rightPos,
        s: Vector2(btnWidth, btnHeight),
        img: Sprite(await Flame.images.load("ui/btn_blue.png")),
        onClick: () {});
    add(btnLeft);
    add(btnRight);

    add(TextComponent(
        text: "暂停游戏",
        position: Vector2(
            bgPos.x + bgSize.x / 2, bgPos.y + (bgSize.y - btnHeight * 1.5) / 2),
        anchor: Anchor.center));
  }

  void closeDialog() {
    close = true;
  }

  void goOn() {
    close = true;
    action = 1;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (close) {
      if (scale.x - 0.1 >= 0) {
        scale = Vector2(scale.x - 0.1, scale.y - 0.1);
      } else {
        close = false;
        removeFromParent();
        onBack();
        if (action == 0) {
          GameController().startGame();
        } else if (action == 1) {
          GameController().startGame();
        } else {
          //退出
          GameController().stopGame();
        }
      }
    }
  }
}
