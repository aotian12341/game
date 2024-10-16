import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:plane/game/image_assets.dart';

import 'game_config.dart';
import 'game_controller.dart';
import 'game_enemy_bullet.dart';

class GameEnemyBulletSnow extends GameEnemyBullet {
  int count = 0;

  GameEnemyBulletSnow(
      {required Vector2 pos,
      required double a,
      required int score,
      required int multiple})
      : super(pos: pos, a: a, score: score, multiple: multiple);

  @override
  Future<void> onLoad() async {
    final image = await Flame.images.load(PlaneImages.bulletEnemy[5]);

    size = Vector2(20.w, 50.w);

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
    double speed = 1;
    if (count < 20) {
      speed = GameConfig.enemyBulletSnowSpeed / 3;
    } else if (count > 20 && count <= 30) {
      speed = 0;
    } else {
      speed = GameConfig.enemyBulletSnowSpeed * 1.0;
    }
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
}
