import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:plane/game/game_config.dart';
import 'package:plane/game/game_enemy.dart';
import 'package:plane/game/game_enemy_bullet.dart';
import 'package:plane/game/game_view.dart';
import 'package:plane/game/image_assets.dart';

import 'game_controller.dart';

class GameHeroBullet extends PositionComponent
    with HasGameRef<GameView>, CollisionCallbacks {
  final Vector2 pos;

  final Image image;

  final Vector2 s;

  double? a;
  bool isStop = false;

  GameHeroBullet(
      {required this.pos, this.a, required this.image, required this.s});

  @override
  Future<void> onLoad() async {
    size = s;

    position = Vector2(pos.x - size.x / 2, pos.y);

    add(SpriteComponent.fromImage(image, size: size));

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

    var moveAngle = a ?? pi;

    if (!isStop) {
      var vs = dt * GameConfig.heroBulletSpeed;
      var vy = sin(pi * 3 / 2 - moveAngle) * vs;
      var vx = cos(pi * 3 / 2 - moveAngle) * vs;

      position = Vector2(position.x + vx, position.y - vy);

      if (position.y > game.size.y || position.y < 0) {
        moveAngle = pi - moveAngle;
        angle = moveAngle;
      } else if (position.x < 0 || position.x > game.size.x) {
        moveAngle = 2 * pi - moveAngle;
        angle = moveAngle;
      }
    }

    if (position.y < 0) {
      removeFromParent();
    }
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other.runtimeType.toString() == "GameEnemy") {
      Future.delayed(const Duration(milliseconds: 0), () {
        GameEnemy enemy = other as GameEnemy;
        if (!enemy.isDeath) {
          removeFromParent();
        }
      });
    }
  }
}
