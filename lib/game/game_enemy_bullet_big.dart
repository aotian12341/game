import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:plane/game/image_assets.dart';

import 'game_config.dart';
import 'game_controller.dart';
import 'game_enemy_bullet.dart';

class GameEnemyBulletBig extends GameEnemyBullet {
  final Vector2 target;

  double moveAngle = -pi;

  GameEnemyBulletBig(
      {required Vector2 pos,
      double? a,
      required this.target,
      required int score,
      required int multiple})
      : super(pos: pos, a: a, score: score, multiple: multiple);

  @override
  Future<void> onLoad() async {
    size = Vector2(17.w, 30.w);
    position = Vector2(pos.x - size.x / 2, pos.y);

    final image = await Flame.images.load(PlaneImages.bulletEnemy[3]);

    final sprite = Sprite(image);

    add(SpriteComponent(sprite: sprite, size: size));

    var k = (-(pos.y - target.y)) / (pos.x - target.x);
    var tempAngle = atan(k);
    tempAngle = tempAngle < 0 ? -(tempAngle + pi / 2) : (pi / 2 - tempAngle);

    moveAngle = tempAngle;
    if (moveAngle < pi / 2 && target.x > pos.x && moveAngle > 0) {
      moveAngle = -pi + moveAngle;
    } else if (target.x <= pos.x && moveAngle <= 0 && moveAngle > -pi / 2) {
      moveAngle = pi + moveAngle;
    }

    angle = moveAngle;

    ShapeHitbox hitBox = RectangleHitbox();

    add(hitBox);

    priority = 10;

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!GameController().isRunning) {
      return;
    }
    if (!isStop) {
      var vs = dt * GameConfig.enemyBulletBigSpeed;
      var vy = sin(pi / 2 * 3 - moveAngle) * vs;
      var vx = cos(pi / 2 * 3 - moveAngle) * vs;

      position = Vector2(position.x + vx, position.y - vy);
    } else {
      removeFromParent();
    }

    if (position.y > game.size.y ||
        position.y < 0 ||
        position.x > game.size.x ||
        position.x < 0) {
      removeFromParent();
    }
  }
}
