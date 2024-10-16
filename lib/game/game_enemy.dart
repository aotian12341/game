import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:plane/game/game_bullet_controller.dart';
import 'package:plane/game/game_config.dart';
import 'package:plane/game/game_controller.dart';
import 'package:plane/game/game_enemy_bullet.dart';
import 'package:plane/game/game_enemy_bullet_big.dart';
import 'package:plane/game/image_assets.dart';
import 'package:plane/game/sound_controller.dart';

import 'enemy_info.dart';
import 'game_enemy_bullet_rotate.dart';
import 'game_enemy_live.dart';
import 'game_enemy_stack.dart';
import 'game_hero_bullet.dart';
import 'game_view.dart';

class GameEnemy extends PositionComponent
    with HasGameRef<GameView>, CollisionCallbacks {
  final EnemyInfo enemyInfo;

  GameEnemy({required this.enemyInfo, required this.multiple});

  late SpriteAnimationComponent death;

  late SpriteComponent spriteComponent;

  bool isDeath = false;

  final int multiple;

  int live = 0;

  late GameEnemyLive enemyLive;
  final boomSpriteList = <Sprite>[];

  int shootType = 0;

  double maxHeight = 0, minHeight = 0;

  Vector2 targetMove = Vector2(0, 0);

  bool isMove = true;

  double moveAngle = pi;

  int type = 0;

  double horizontalMove = 0;

  @override
  Future<void> onLoad() async {
    final spriteList = <Sprite>[];

    size = Vector2(enemyInfo.size.x, enemyInfo.size.y + 10.w);

    live = enemyInfo.live;

    var x = Random().nextDouble() * (game.size.x - size.x);

    position = Vector2(x, 10.w);

    final sprite = Sprite(await Flame.images.load(enemyInfo.imagePath));

    spriteComponent = SpriteComponent(sprite: sprite, size: size);

    for (var str in PlaneImages.boom) {
      Sprite sprite = Sprite(await Flame.images.load(str));
      spriteList.add(sprite);
    }

    death = SpriteAnimationComponent(
        animation: SpriteAnimation.spriteList(spriteList, stepTime: 0.1),
        size: size);

    add(spriteComponent);

    shoot();

    ShapeHitbox hitBox = RectangleHitbox();

    add(hitBox);

    final liveSize = Vector2(min(size.x, 30.w), 5.w);
    final livePos = Vector2((size.x - liveSize.x) / 2, 0);

    enemyLive = GameEnemyLive(s: liveSize, pos: livePos, live: live);

    // add(enemyLive);

    for (var str in PlaneImages.boom) {
      Sprite sprite = Sprite(await Flame.images.load(str));
      boomSpriteList.add(sprite);
    }

    shootType = Random().nextInt(GameBulletController().total);

    maxHeight = game.size.y / 2.5 - size.y;
    minHeight = game.size.y / 4;

    horizontalMove = position.x + minHeight;

    priority = 10;

    return super.onLoad();
  }

  void boom() {
    isDeath = true;
    add(death);
    SoundController().playBoom();
    Future.delayed(const Duration(seconds: 1), () {
      removeFromParent();
      GameController().removeEnemyData(enemyInfo);
    });
  }

  void shootBig() {
    final bullet = GameEnemyBulletBig(
        pos: Vector2(position.x + size.x / 2, position.y + size.y),
        target: GameController().heroPos,
        score: enemyInfo.score,
        multiple: multiple);
    game.add(bullet);
  }

  void shoot() async {
    if (isDeath) {
      return;
    }
    if (!GameController().isRunning) {
      return;
    }
    var bulletData = [];
    var bulletList = <PositionComponent>[];
    if (shootType == 0) {
      GameBulletController().shootSnowflake(
          Vector2(position.x + size.x / 4, position.y + size.y / 4),
          enemyInfo.score,
          multiple);
    } else if (shootType == 1) {
      GameBulletController().shootSector(
          Vector2(position.x + size.x / 2, position.y + size.y),
          enemyInfo.score,
          multiple);
    } else if (shootType == 2) {
      shootStack();
    } else if (shootType == 3) {
      shootRotate();
    }

    for (var pos in bulletData) {
      GameEnemyBullet bullet = GameEnemyBullet(
          pos: pos["pos"],
          a: pos["angle"],
          score: enemyInfo.score,
          multiple: multiple);
      bulletList.add(bullet);
    }

    game.addAll(bulletList);

    await Future.delayed(
        Duration(milliseconds: GameConfig.enemyBulletCreateSpeed));

    shoot();

    // if (Random().nextInt(100) > 80) {
    //   bulletList.add(GameEnemyBulletBig(
    //       pos: Vector2(position.x + size.x / 2, position.y + size.y),
    //       target: GameController().heroPos,
    //       score: enemyInfo.score,
    //       multiple: multiple));
    // }
  }

  void shootStack() async {
    List<GameEnemyStack> bulletList = await GameBulletController().shootStack(
        Vector2(position.x + size.x / 2, position.y + size.y),
        enemyInfo.score,
        multiple);

    // await Future.delayed(const Duration(seconds: 1));
    //
    // for (final bullet in bulletList) {
    //   bullet.move();
    // }
  }

  void shootRotate() async {
    List<GameEnemyBulletRotate> bulletList = await GameBulletController()
        .shootRotate(Vector2(position.x + size.x / 2, position.y + size.y),
            enemyInfo.score, multiple);

    // await Future.delayed(const Duration(milliseconds: 2000));

    for (final bullet in bulletList) {
      bullet.move();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!GameController().isRunning) {
      return;
    }
    double speed = GameConfig.enemyMoveSpeed;
    if (!isMove) {
      speed = 0;
    }

    var vs = dt * speed;
    var vy = sin(pi / 2 - moveAngle) * vs;
    var vx = cos(pi / 2 - moveAngle) * vs;
    position = Vector2(position.x + vx, position.y - vy);

    if (position.y >= maxHeight && type == 0) {
      stopMove();
    } else if (position.y <= minHeight && type == 1) {
      stopMove();
    } else if (position.x >= horizontalMove &&
        moveAngle > 0 &&
        moveAngle != pi) {
      stopMove();
    } else if (position.x <= horizontalMove &&
        moveAngle < 0 &&
        moveAngle != pi) {
      stopMove();
    }

    if (position.y > game.size.y) {
      isDeath = true;
      removeFromParent();
      GameController().removeEnemyData(enemyInfo);
    }
  }

  void stopMove() {
    // isMove = false;
    // moveAngle = 1.0;

    // Future.delayed(const Duration(seconds: 2), () {
    //   isMove = true;
    // });
    isMove = false;
    if (Random().nextInt(2) == 0) {
      moveAngle = Random().nextDouble() * pi / 4 + 0.5;
      horizontalMove = position.x + minHeight;
      if (horizontalMove >= game.size.x - size.x) {
        horizontalMove = game.size.x - size.x;
      }
    } else {
      moveAngle = -(Random().nextDouble() * pi / 4 + 0.5);
      horizontalMove = position.x - minHeight;
      if (horizontalMove <= 0) {
        horizontalMove = 0;
      }
    }
    type = type == 0 ? 1 : 0;
    if (type == 0) {
      moveAngle = pi;
    }

    Future.delayed(const Duration(seconds: 2), () {
      isMove = true;
    });
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // canvas.save();
    // canvas.drawRect(
    //     Rect.fromLTWH(0, 0, size.x, size.y),
    //     Paint()
    //       ..color = Colors.red
    //       ..style = PaintingStyle.stroke
    //       ..strokeWidth = 5);
    //
    // canvas.restore();
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other.runtimeType.toString() == "GameHeroBullet") {
      showBoom((other as GameHeroBullet).position);
      GameController().onEnemyBoom(
          {"id": enemyInfo.id, "score": enemyInfo.score * multiple});
    }
  }

  void showBoom(Vector2 hitPos) async {
    final boom = SpriteAnimationComponent(
        animation: SpriteAnimation.spriteList(boomSpriteList, stepTime: 0.01),
        size: Vector2(40.w, 40.w));
    boom.position = Vector2(hitPos.x - position.x, hitPos.y - position.y);
    add(boom);
    await Future.delayed(const Duration(seconds: 1));
    boom.removeFromParent();
  }
}
