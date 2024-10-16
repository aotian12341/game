import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:plane/game/game_view.dart';

import 'game_config.dart';
import 'game_controller.dart';
import 'image_assets.dart';

class GameEnemyBulletNormal extends PositionComponent
    with HasGameRef<GameView>, CollisionCallbacks {
  final Vector2 pos;

  double? a;

  bool isStop = false;

  final int score;

  final int multiple;

  GameEnemyBulletNormal(
      {required this.pos, this.a, required this.score, required this.multiple});

  @override
  Future<void> onLoad() async {
    var image = await Flame.images.load(PlaneImages.bulletEnemy[0]);

    size = Vector2(8.w, 28.w);
    position = Vector2(pos.x - size.x / 2, pos.y);
    add(SpriteComponent(sprite: Sprite(image), size: size));

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

    var moveAngle = a ?? -pi;

    if (!isStop) {
      var vs = dt * GameConfig.enemyBulletSpeed;
      var vy = sin(pi / 2 - moveAngle) * vs;
      var vx = cos(pi / 2 - moveAngle) * vs;

      position = Vector2(position.x + vx, position.y - vy);

      if (position.y > game.size.y || position.y < 0) {
        moveAngle = pi - moveAngle;
        angle = moveAngle;
      } else if (position.x < 0 || position.x > game.size.x) {
        moveAngle = 2 * pi - moveAngle;
        angle = moveAngle;
      }
    }

    if (position.y > game.size.y) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // canvas.save();
    // canvas.drawRect(
    //     Rect.fromLTWH(0, 0, size.x, size.y),
    //     Paint()
    //       ..color = Colors.green
    //       ..style = PaintingStyle.stroke
    //       ..strokeWidth = 5);
    //
    // canvas.restore();
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other.runtimeType.toString() == "GameHero") {
      Future.delayed(const Duration(milliseconds: 0), () async {
        removeFromParent();
      });
    }
  }
}
