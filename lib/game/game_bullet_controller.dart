import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:plane/game/game_controller.dart';
import 'package:plane/game/game_enemy_bullet.dart';

import 'game_enemy_bullet_rotate.dart';
import 'game_enemy_bullet_snow.dart';
import 'game_enemy_stack.dart';

class GameBulletController {
  ///
  factory GameBulletController() => _getInstance();

  // 静态私有成员，没有初始化
  static GameBulletController? _instance;

  // 静态、同步、私有访问点
  static GameBulletController _getInstance() {
    _instance ??= GameBulletController._internal();
    return _instance!;
  }

  // 私有构造函数
  GameBulletController._internal() {
    // init();
  }

  // 游戏控制对象
  late FlameGame game;

  void setGame(FlameGame game) {
    this.game = game;
  }

  final total = 4;

  void shootSnowflake(Vector2 pos, int score, int multiple) {
    List<Vector2> posList = [];
    const count = 6;
    const angle = pi / count;
    List<PositionComponent> bulletList = [];

    posList = [
      Vector2(pos.x + 10.w, pos.y + 60.w),
      Vector2(pos.x + 10.w, pos.y + 0.w),
      Vector2(pos.x - 5.w, pos.y + 30.w),
      Vector2(pos.x + 60.w, pos.y + 30.w),
      Vector2(pos.x + 45.w, pos.y + 60.w),
      Vector2(pos.x + 45.w, pos.y + 0.w),
      Vector2(pos.x - 15.w, pos.y + 100.w),
      Vector2(pos.x - 15.w, pos.y - 40.w),
      Vector2(pos.x - 55.w, pos.y + 30.w),
      Vector2(pos.x + 110.w, pos.y + 30.w),
      Vector2(pos.x + 65.w, pos.y + 100.w),
      Vector2(pos.x + 65.w, pos.y - 40.w)
    ];
    final angleList = [
      pi + angle,
      -angle,
      -pi / 2,
      pi / 2,
      pi - angle,
      angle,
      pi + angle,
      -angle,
      -pi / 2,
      pi / 2,
      pi - angle,
      angle
    ];

    for (int i = 0; i < posList.length; i++) {
      bulletList.add(GameEnemyBulletSnow(
          pos: posList[i],
          ang: angleList[i],
          score: score,
          multiple: multiple));
    }

    game.addAll(bulletList);
  }

  void shootSector(Vector2 pos, int score, int multiple) async {
    shootSectorDetails(pos, score, multiple);
    await Future.delayed(const Duration(milliseconds: 100));
    shootSectorDetails(pos, score, multiple);
    await Future.delayed(const Duration(milliseconds: 100));
    shootSectorDetails(pos, score, multiple);
    await Future.delayed(const Duration(milliseconds: 100));
    shootSectorDetails(pos, score, multiple);
  }

  void shootSectorDetails(Vector2 pos, int score, int multiple) {
    List<Vector2> posList = [];
    List<double> angleList = [];
    List<PositionComponent> bulletList = [];

    posList.add(Vector2(pos.x + 15.w, pos.y));
    posList.add(Vector2(pos.x + 7.5.w, pos.y));
    posList.add(Vector2(pos.x, pos.y));
    posList.add(Vector2(pos.x - 7.5.w, pos.y));
    posList.add(Vector2(pos.x - 15.w, pos.y));

    angleList.add(pi - 0.4);
    angleList.add(pi - 0.2);
    angleList.add(pi);
    angleList.add(pi + 0.2);
    angleList.add(pi + 0.4);

    for (int i = 0; i < posList.length; i++) {
      bulletList.add(GameEnemyBulletSnow(
          pos: posList[i],
          ang: angleList[i],
          score: score,
          multiple: multiple));
    }

    game.addAll(bulletList);
  }

  Future<List<GameEnemyStack>> shootStack(
      Vector2 pos, int score, int multiple) async {
    final bulletList = <GameEnemyStack>[];
    Vector2 target = GameController().heroPos;
    bulletList.addAll(shootStackDetails(pos, target, score, multiple));
    await Future.delayed(const Duration(milliseconds: 100));
    bulletList.addAll(shootStackDetails(pos, target, score, multiple));

    return bulletList;
  }

  List<GameEnemyStack> shootStackDetails(
      Vector2 pos, Vector2 target, int score, int multiple) {
    const count = 10;
    var k = (-(pos.y - target.y)) / (pos.x - target.x);
    var tempAngle = atan(k);
    tempAngle = tempAngle < 0 ? -(tempAngle + pi / 2) : (pi / 2 - tempAngle);

    double moveAngle = tempAngle;
    if (moveAngle < pi / 2 && target.x > pos.x && moveAngle > 0) {
      moveAngle = -pi + moveAngle;
    } else if (target.x <= pos.x && moveAngle <= 0 && moveAngle > -pi / 2) {
      moveAngle = pi + moveAngle;
    }

    final maxA = moveAngle + 0.2, minA = moveAngle - 0.2;

    final temp = (maxA - minA) / count;

    final bulletList = <GameEnemyStack>[];

    for (var i = 0; i < count; i++) {
      final angle = minA + temp * i + pi;
      bulletList.add(GameEnemyStack(
          pos: pos, ang: angle, score: score, multiple: multiple));
    }

    game.addAll(bulletList);

    return bulletList;
  }

  Future<List<GameEnemyBulletRotate>> shootRotate(
      Vector2 pos, int score, int multiple) async {
    const count = 10;
    const angle = pi / count;

    final bulletList = <GameEnemyBulletRotate>[];

    for (int i = 0; i < count * 2; i++) {
      final bullet = GameEnemyBulletRotate(
          pos: pos, ang: -pi + angle * i, score: score, multiple: multiple);
      bulletList.add(bullet);
      game.add(bullet);

      await Future.delayed(const Duration(milliseconds: 5));
    }

    return bulletList;
  }
}
