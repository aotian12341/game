import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'game_config.dart';
import 'game_controller.dart';
import 'game_enemy_bullet.dart';

class GameEnemyBulletStack extends GameEnemyBullet {
  bool isMove = true;

  int count = 0;

  GameEnemyBulletStack(
      {required Vector2 pos,
      double? a,
      required int score,
      required int multiple})
      : super(pos: pos, a: a, score: score, multiple: multiple);

  @override
  Future<void> onLoad() async {
    final image1 = await Flame.images.load("enemy/enemy_bullet_big1.png");
    final image2 = await Flame.images.load("enemy/enemy_bullet_big2.png");

    final spriteList = <Sprite>[];
    spriteList.add(Sprite(image1));
    spriteList.add(Sprite(image2));

    size = Vector2(20.w, 20.w);

    SpriteAnimationComponent animationComponent = SpriteAnimationComponent(
        animation: SpriteAnimation.spriteList(spriteList, stepTime: 0.2),
        size: size);

    add(animationComponent);

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
    if (!GameController().isRunning) {
      return;
    }

    var moveAngle = a ?? -pi;

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
}
