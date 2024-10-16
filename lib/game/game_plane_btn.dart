import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:plane/game/game_controller.dart';
import 'package:plane/game/game_view.dart';

import 'game_sprite_btn.dart';

// 右下角的子弹控制UI
class GamePlaneBtn extends PositionComponent with HasGameRef<GameView> {
  final Function onIndexChange;

  GamePlaneBtn({required this.onIndexChange});

  late SpriteSheet numbers;

  late PositionComponent numSprite;

  @override
  Future<void> onLoad() async {
    // 左右箭头
    final image = await Flame.images.load("ui/page-arrow.png");

    // 数字
    numbers = SpriteSheet.fromColumnsAndRows(
        image: await Flame.images.load("ui/ranking-num02.png"),
        columns: 10,
        rows: 1);

    size = Vector2(140.w, 40.w);

    final left = SpriteBtn(
      pos: Vector2(20.w, 20.w),
      s: Vector2(40.w, 40.w),
      spriteAngle: pi,
      img: Sprite(image),
      onClick: () {
        GameController().planeIndex -= 1;
        if (GameController().planeIndex < 0) {
          GameController().planeIndex =
              GameController().multipleList.length - 1;
        }
        onIndexChange();
        setMultiple();
      },
    );

    final right = SpriteBtn(
      pos: Vector2(100.w, 0),
      s: Vector2(40.w, 40.w),
      img: Sprite(image),
      onClick: () {
        GameController().planeIndex += 1;
        if (GameController().planeIndex >
            GameController().multipleList.length - 1) {
          GameController().planeIndex = 0;
        }
        onIndexChange();
        setMultiple();
      },
    );

    numSprite = PositionComponent(size: Vector2(40.w, 40.w));
    numSprite.position = Vector2(35.w, 10.w);

    addAll([left, numSprite, right]);

    position = Vector2(game.size.x - 140.w, game.size.y - 40.w);

    setMultiple();

    // 设置层级
    priority = 998;

    return super.onLoad();
  }

  // 更新子弹等级
  void setMultiple() {
    final temp = GameController().multipleList[GameController().planeIndex];
    final str = "$temp".split("");
    const l = 4;
    final spriteList = <SpriteComponent>[];
    for (int i = 0; i < l - str.length; i++) {
      spriteList.add(SpriteComponent(
          sprite: numbers.getSprite(0, 0),
          size: Vector2(20.w, 20.w),
          position: Vector2(spriteList.length * 17.w, 0)));
    }
    for (int i = 0; i < str.length; i++) {
      spriteList.add(SpriteComponent(
          sprite: numbers.getSprite(0, int.parse(str[i])),
          size: Vector2(20.w, 20.w),
          position: Vector2(spriteList.length * 17.w, 0)));
    }

    numSprite.removeAll(numSprite.children);
    numSprite.addAll(spriteList);
  }
}
