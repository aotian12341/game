import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:plane/game/game_view.dart';

import 'game_config.dart';
import 'game_controller.dart';

class GameEnemyStack extends SpriteAnimationComponent
    with HasGameRef<GameView>, CollisionCallbacks {
  final Vector2 pos;

  final double? ang;

  bool isStop = false;

  final int score;

  final int multiple;

  bool isMove = true;

  int count = 0;

  GameEnemyStack(
      {required this.pos,
      this.ang,
      required this.score,
      required this.multiple});

  @override
  Future<void> onLoad() async {
    final image1 = await Flame.images.load("enemy/enemy_bullet_big1.png");
    final image2 = await Flame.images.load("enemy/enemy_bullet_big2.png");

    final spriteList = <Sprite>[];
    spriteList.add(Sprite(image1));
    spriteList.add(Sprite(image2));

    animation = SpriteAnimation.spriteList(spriteList, stepTime: 0.2);

    size = Vector2(20.w, 20.w);

    position = pos;

    ShapeHitbox hitBox = RectangleHitbox();

    add(hitBox);

    priority = 10;

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    count += 1;

    // if (!isMove) {
    //   return;
    // }
    // if (count == 50) {
    //   isMove = false;
    // } else if (count == 70) {
    //   isMove = true;
    // }
    if (!GameController().isRunning) {
      return;
    }

    var moveAngle = ang ?? -pi;

    if (!isStop) {
      var vs = dt * GameConfig.enemyBulletSpeed;
      var vy = sin(pi / 2 - moveAngle) * vs;
      var vx = cos(pi / 2 - moveAngle) * vs;

      position = Vector2(position.x + vx, position.y - vy);
    }

    if (position.y > game.size.y ||
        position.y < 0 ||
        position.x > game.size.x ||
        position.x < 0) {
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
