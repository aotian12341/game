import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:plane/game/game_view.dart';

import 'game_config.dart';
import 'game_controller.dart';
import 'image_assets.dart';

class GameEnemyBulletRotate extends PositionComponent
    with HasGameRef<GameView>, CollisionCallbacks {
  final Vector2 pos;

  final double ang;

  bool isStop = false;

  final int score;

  final int multiple;

  int count = 0;

  bool isMove = false;

  GameEnemyBulletRotate(
      {required this.pos,
      required this.ang,
      required this.score,
      required this.multiple});

  @override
  Future<void> onLoad() async {
    final image = await Flame.images.load(PlaneImages.bulletEnemy[4]);

    size = Vector2(20.w, 45.w);

    angle = ang;

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

    if (!isMove) {
      return;
    }
    // if (count == 50) {
    //   isMove = false;
    // }
    // if (count < 20) {
    //   speed = GameConfig.enemyBulletSnowSpeed / 3;
    // } else if (count > 20 && count <= 30) {
    //   speed = 0;
    // } else {
    //   speed = GameConfig.enemyBulletSnowSpeed * 1.0;
    // }
    if (!GameController().isRunning) {
      return;
    }
    if (!isStop) {
      var vs = dt * speed; //GameConfig.enemyBulletSnowSpeed;
      var vy = sin(pi / 2 - ang) * vs;
      var vx = cos(pi / 2 - ang) * vs;

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
