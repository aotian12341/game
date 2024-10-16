import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
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
import 'game_enemy_bullet_stack.dart';
import 'game_hero_bullet.dart';
import 'game_view.dart';

// 敌机
class GameEnemy extends PositionComponent
    with HasGameRef<GameView>, CollisionCallbacks {
  final EnemyInfo enemyInfo;

  GameEnemy({required this.enemyInfo, required this.multiple});

  // 爆炸动画
  late SpriteAnimationComponent death;

  // 敌机精灵
  late SpriteComponent spriteComponent;

  // 敌机状态
  bool isDeath = false;

  // 击中倍数
  final int multiple;

  // 生命值
  int live = 0;

  // 生命值组件
  late GameEnemyLive enemyLive;

  // 击中爆炸精灵图
  final boomSpriteList = <Sprite>[];

  // 子弹类型0梅花，1扇形直道，2扇形，3圆形
  int shootType = 0;

  // 最大、最小移动高度
  double maxHeight = 0, minHeight = 0;

  // 是否移动
  bool isMove = true;

  // 移动角度
  double moveAngle = pi;

  // 敌机类型
  int type = 0;

  // 横向移动最大距离
  double horizontalMove = 0;

  @override
  Future<void> onLoad() async {
    // 初始化飞机
    size = Vector2(enemyInfo.size.x, enemyInfo.size.y + 10.w);

    live = enemyInfo.live;

    var x = Random().nextDouble() * (game.size.x - size.x);

    position = Vector2(x, 10.w);

    final sprite = Sprite(await Flame.images.load(enemyInfo.imagePath));

    spriteComponent = SpriteComponent(sprite: sprite, size: size);

    // 初始化爆炸
    for (var str in PlaneImages.boom) {
      Sprite sprite = Sprite(await Flame.images.load(str));
      boomSpriteList.add(sprite);
    }

    // 爆炸动画
    death = SpriteAnimationComponent(
        animation: SpriteAnimation.spriteList(boomSpriteList, stepTime: 0.1),
        size: size);

    add(spriteComponent);

    // 添加碰撞体
    ShapeHitbox hitBox = RectangleHitbox();

    add(hitBox);

    // 设置生命
    final liveSize = Vector2(min(size.x, 30.w), 5.w);
    final livePos = Vector2((size.x - liveSize.x) / 2, 0);

    enemyLive = GameEnemyLive(s: liveSize, pos: livePos, live: live);

    add(enemyLive);

    // 设置子弹类型
    shootType = Random().nextInt(GameBulletController().total);
    // 发射子弹
    shoot();

    // 初始化移动数据
    maxHeight = game.size.y / 2.5 - size.y;
    minHeight = game.size.y / 4;
    horizontalMove = position.x + minHeight;

    priority = 10;

    return super.onLoad();
  }

  // 爆炸
  void boom() {
    isDeath = true;
    add(death);
    SoundController().playBoom();
    Future.delayed(const Duration(seconds: 1), () {
      removeFromParent();
      GameController()
          .onEnemyBoom({"multiple": multiple, "score": enemyInfo.score});
      GameController().removeEnemyData(enemyInfo);
    });
  }

  // 发射子弹
  void shoot() async {
    if (isDeath) {
      return;
    }
    if (!GameController().isRunning) {
      return;
    }
    var bulletData = [];
    var bulletList = <PositionComponent>[];

    // 发射巡航导弹
    if (Random().nextInt(100) > 80) {
      bulletList.add(GameEnemyBulletBig(
          pos: Vector2(position.x + size.x / 2, position.y + size.y),
          target: GameController().heroPos,
          score: enemyInfo.score,
          multiple: multiple));
    } else {
      // 发射普通子弹
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

      // GameBulletController()
      //     .shootSnowflake(position, enemyInfo.score, multiple);

      // GameBulletController().shootStack(
      //     Vector2(position.x + size.x / 2, position.y + size.y),
      //     enemyInfo.score,
      //     multiple);

      // GameBulletController().shootRotate(
      //     Vector2(position.x + size.x / 2, position.y + size.y),
      //     enemyInfo.score,
      //     multiple);
      // GameBulletController().shootSector(
      //     Vector2(position.x + size.x / 2, position.y + size.y),
      //     enemyInfo.score,
      //     multiple);
      // if (enemyInfo.type == 0) {
      //   var a = size.x / 3;
      //   var b = position.y + size.y;
      //   bulletData.add({"pos": Vector2(position.x + a, b)});
      //   bulletData.add({"pos": Vector2(position.x + a * 2, b)});
      // } else if (enemyInfo.type == 1) {
      //   var a = size.x / 4;
      //   var b = position.y + size.y;
      //   bulletData.add({"pos": Vector2(position.x + a, b)});
      //   bulletData.add({"pos": Vector2(position.x + a * 2, b)});
      //   bulletData.add({"pos": Vector2(position.x + a * 3, b)});
      // } else if (enemyInfo.type == 2) {
      //   var a = size.x / 5;
      //   var b = position.y + size.y;
      //   bulletData.add({"pos": Vector2(position.x + a, b), "angle": -pi + 0.1});
      //   bulletData.add({"pos": Vector2(position.x + a * 2, b)});
      //   bulletData.add({"pos": Vector2(position.x + a * 3, b)});
      //   bulletData
      //       .add({"pos": Vector2(position.x + a * 4, b), "angle": -pi - 0.1});
      // }
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
  }

  void shootStack() async {
    List<GameEnemyBulletStack> bulletList = await GameBulletController()
        .shootStack(Vector2(position.x + size.x / 2, position.y + size.y),
            enemyInfo.score, multiple);
  }

  void shootRotate() async {
    List<GameEnemyBulletRotate> bulletList = await GameBulletController()
        .shootRotate(Vector2(position.x + size.x / 2, position.y + size.y),
            enemyInfo.score, multiple);
    // await Future.delayed(const Duration(milliseconds: 500));
    // for (final bullet in bulletList) {
    //   bullet.move();
    // }
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

    // 移动到当前限制，停2秒
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

  // 移动到限制，设置下一个移动位置
  void stopMove() {
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
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    // 被子弹击中
    if (other.runtimeType.toString() == "GameHeroBullet") {
      if (live > 0) {
        live -= 1;
      }
      enemyLive.updateLive(live);
      showBoom((other as GameHeroBullet).position);
      if (live == 0) {
        Future.delayed(const Duration(milliseconds: 0), () {
          if (!isDeath) {
            boom();
          }
        });
      }
    }
  }

  // 显示被击中动画
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
