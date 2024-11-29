import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:plane/game/game_config.dart';
import 'package:plane/game/game_controller.dart';
import 'package:plane/game/game_enemy_bullet.dart';
import 'package:plane/game/game_hero_bullet.dart';
import 'package:plane/game/sound_controller.dart';

import 'game_enemy_bullet_big.dart';
import 'game_enemy_bullet_rotate.dart';
import 'game_enemy_bullet_snow.dart';
import 'game_enemy_stack.dart';
import 'game_view.dart';
import 'image_assets.dart';

class GameHero extends PositionComponent
    with HasGameRef<GameView>, CollisionCallbacks {
  // 当前玩家飞机索引
  int index = 0;

  // 当前图片精灵，用于变更飞机图片
  SpriteComponent? heroSprite;

  // 被击中时的精灵图里列表
  final boomSpriteList = <Sprite>[];

  @override
  Future<void> onLoad() async {
    // 初始化主机
    final image = await Flame.images.load(PlaneImages.hero[index]);
    size = Vector2(60.w, 51.w);
    position = Vector2(game.size.x / 2 - size.x / 2, game.size.y * 2 / 3);
    heroSprite = SpriteComponent(sprite: Sprite(image), size: size);
    add(heroSprite!);

    // 设置主机当前位置
    GameController()
        .setHeroPos(Vector2(position.x + size.x / 2, position.y + size.y / 2));

    // 添加圆形碰撞体
    ShapeHitbox hitBox = CircleHitbox(radius: size.y / 2);
    add(hitBox);

    // 游戏组件层级
    priority = 10;

    // 加载击中时的精灵图
    for (var str in PlaneImages.boom) {
      Sprite sprite = Sprite(await Flame.images.load(str));
      boomSpriteList.add(sprite);
    }
    return super.onLoad();
  }

  // 子弹等级索引变更时触发，每个等级有5种颜色不同的子弹
  void planeChange() async {
    index = GameController().planeIndex ~/ 5;

    heroSprite?.removeFromParent();

    // 根据飞机索引加载对应的飞机图
    final image = await Flame.images.load(PlaneImages.hero[index]);
    final tempSize = size;
    if (index == 0) {
      size = Vector2(60.w, 51.w);
      position = Vector2(position.x - tempSize.x / 2 + size.x / 2, position.y);
    } else if (index == 1) {
      size = Vector2(65.w, 51.w);
      position = Vector2(position.x - tempSize.x / 2 + size.x / 2, position.y);
    } else if (index == 2) {
      size = Vector2(65.w, 58.w);
      position = Vector2(position.x - tempSize.x / 2 + size.x / 2, position.y);
    } else if (index == 3) {
      size = Vector2(65.w, 60.w);
      position = Vector2(position.x - tempSize.x / 2 + size.x / 2, position.y);
    }

    heroSprite = SpriteComponent(sprite: Sprite(image), size: size);

    add(heroSprite!);
  }

  // 玩家飞机移动，不可以移出屏幕
  void move(Vector2 pos) {
    var x = pos.x, y = pos.y;
    if (x - size.x / 2 <= 0) {
      x = size.x / 2;
    } else if (x >= game.size.x - size.x / 2) {
      x = game.size.x - size.x / 2;
    }
    if (y < size.y / 2) {
      y = size.y / 2;
    } else if (y > game.size.y - size.y / 2) {
      y = game.size.y - size.y / 2;
    }

    position = Vector2(x - size.x / 2, y - size.y / 2);

    // 每次移动后更新玩家飞机位置(用户放巡航导弹)
    GameController()
        .setHeroPos(Vector2(position.x + size.x / 2, position.y + size.y / 2));
  }

  // 发射子弹
  void shoot() async {
    if (!GameController().isRunning) {
      return;
    }

    final bulletList = <PositionComponent>[];

    // 根据不同的子弹等级，加载子弹图片与数量
    if (GameController().planeIndex < 5) {
      final image = await Flame.images
          .load(PlaneImages.bulletHero[0][GameController().planeIndex]);
      final s = Vector2(15.w, 25.w);
      bulletList.add(GameHeroBullet(
          pos: Vector2(position.x + size.x / 2, position.y),
          isBullet: true,
          image: image,
          s: s));
    } else if (GameController().planeIndex >= 5 &&
        GameController().planeIndex < 10) {
      final image = await Flame.images.load(PlaneImages.bulletHero[1]
          [GameController().planeIndex - PlaneImages.bulletHero[0].length]);
      final s = Vector2(10.w, 55.w);
      bulletList.add(GameHeroBullet(
          pos: Vector2(position.x + size.x / 3, position.y),
          isBullet: true,
          image: image,
          s: s));
      bulletList.add(GameHeroBullet(
          pos: Vector2(position.x + size.x * 2 / 3, position.y),
          image: image,
          s: s));
    } else if (GameController().planeIndex >= 10 &&
        GameController().planeIndex < 15) {
      final image = await Flame.images.load(PlaneImages.bulletHero[2][
          GameController().planeIndex -
              PlaneImages.bulletHero[0].length -
              PlaneImages.bulletHero[1].length]);
      final s = Vector2(26.w, 50.w);
      bulletList.add(GameHeroBullet(
          pos: Vector2(position.x + size.x / 4, position.y),
          image: image,
          s: s));
      bulletList.add(GameHeroBullet(
          pos: Vector2(position.x + size.x * 3 / 4, position.y),
          image: image,
          s: s));

      final image2 = await Flame.images.load(PlaneImages.bulletHero[2][5]);
      final s2 = Vector2(14.w, 40.w);
      bulletList.add(GameHeroBullet(
          pos: Vector2(position.x + size.x * 2 / 4, position.y),
          image: image2,
          isBullet: true,
          s: s2));
    } else {
      final image = await Flame.images
          .load(PlaneImages.bulletHero[2][GameController().planeIndex % 5]);
      final s = Vector2(26.w, 50.w);
      bulletList.add(GameHeroBullet(
          pos: Vector2(position.x + size.x * 1 / 4, position.y - 5.w),
          image: image,
          s: s));
      bulletList.add(GameHeroBullet(
          pos: Vector2(position.x + size.x * 3 / 4, position.y - 5.w),
          image: image,
          s: s));

      final image2 = await Flame.images.load(PlaneImages.bulletHero[2][5]);
      final s2 = Vector2(14.w, 40.w);
      bulletList.add(GameHeroBullet(
          pos: Vector2(position.x + size.x * 2 / 4, position.y - 10.w),
          isBullet: true,
          image: image2,
          s: s2));

      final image3 = await Flame.images
          .load(PlaneImages.bulletHero[1][GameController().planeIndex % 5]);
      final s3 = Vector2(10.w, 55.w);

      bulletList.add(GameHeroBullet(
          pos: Vector2(position.x + size.x * 0 / 4, position.y),
          image: image3,
          s: s3));
      bulletList.add(GameHeroBullet(
          pos: Vector2(position.x + size.x * 4 / 4, position.y),
          image: image3,
          s: s3));
    }

    game.addAll(bulletList);
    // 发射子弹播放声音
    SoundController().playShoot();

    await Future.delayed(
        Duration(milliseconds: GameConfig.heroBulletCreateSpeed));
    // await Future.delayed(Duration(milliseconds: 2000));

    shoot();
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    // 当玩家飞机被打中时，产生爆炸效果，扣除对应分数

    if (other.runtimeType.toString() == "GameEnemyBullet") {
      Future.delayed(const Duration(milliseconds: 0), () async {
        GameEnemyBullet bullet = other as GameEnemyBullet;

        GameController()
            .onHeroHit({"multiple": bullet.multiple, "score": bullet.score});

        showBoom(bullet.position);
      });
    } else if (other.runtimeType.toString() == "GameEnemyBulletBig") {
      Future.delayed(const Duration(milliseconds: 0), () async {
        GameEnemyBulletBig bullet = other as GameEnemyBulletBig;

        GameController()
            .onHeroHit({"multiple": bullet.multiple, "score": bullet.score});

        showBoom(bullet.position);
      });
    } else if (other.runtimeType.toString() == "GameEnemyBulletSnow") {
      Future.delayed(const Duration(milliseconds: 0), () async {
        GameEnemyBulletSnow bullet = other as GameEnemyBulletSnow;

        GameController()
            .onHeroHit({"multiple": bullet.multiple, "score": bullet.score});

        showBoom(bullet.position);
      });
    } else if (other.runtimeType.toString() == "GameEnemyStack") {
      Future.delayed(const Duration(milliseconds: 0), () async {
        GameEnemyStack bullet = other as GameEnemyStack;

        GameController()
            .onHeroHit({"multiple": bullet.multiple, "score": bullet.score});

        showBoom(bullet.position);
      });
    } else if (other.runtimeType.toString() == "GameEnemyBulletRotate") {
      Future.delayed(const Duration(milliseconds: 0), () async {
        GameEnemyBulletRotate bullet = other as GameEnemyBulletRotate;

        GameController()
            .onHeroHit({"multiple": bullet.multiple, "score": bullet.score});

        showBoom(bullet.position);
      });
    }
  }

  void showBoom(Vector2 hitPos) async {
    final boom = SpriteAnimationComponent(
        animation: SpriteAnimation.spriteList(boomSpriteList, stepTime: 0.01),
        size: Vector2(40.w, 40.w));
    boom.position = Vector2(hitPos.x - position.x, hitPos.y - position.y);
    add(boom);
    SoundController().playHeroHit();
    await Future.delayed(const Duration(milliseconds: 300));
    boom.removeFromParent();
  }
}
