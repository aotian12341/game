import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'game_config.dart';
import 'game_controller.dart';
import 'game_enemy_bullet.dart';
import 'image_assets.dart';

class GameEnemyBulletRotate extends GameEnemyBullet {
  int count = 0;

  bool isMove = false;

  GameEnemyBulletRotate(
      {required Vector2 pos,
      required double a,
      required int score,
      required int multiple})
      : super(pos: pos, a: a, score: score, multiple: multiple);

  @override
  Future<void> onLoad() async {
    final image = await Flame.images.load(PlaneImages.bulletEnemy[4]);

    size = Vector2(20.w, 45.w);

    angle = a!;

    position = pos;

    anchor = Anchor.center;

    final sprite = Sprite(image);

    add(SpriteComponent(sprite: sprite, size: size));

    ShapeHitbox hitBox = RectangleHitbox();

    add(hitBox);

    priority = 10;

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    count += 1;
    double speed = GameConfig.enemyBulletSnowSpeed / 3;
    // if (count == 30) {
    //   isMove = false;
    // }

    // if (!isMove) {
    //   return;
    // }
    if (!GameController().isRunning) {
      return;
    }
    if (!isStop) {
      var vs = dt * speed; //GameConfig.enemyBulletSnowSpeed;
      var vy = sin(pi / 2 - a!) * vs;
      var vx = cos(pi / 2 - a!) * vs;

      position = Vector2(position.x + vx, position.y - vy);
    }

    if (position.y > game.size.y ||
        position.y < 0 ||
        position.x < 0 ||
        position.x > game.size.x) {
      removeFromParent();
    }
  }

  void move() {
    isMove = true;
  }
}
