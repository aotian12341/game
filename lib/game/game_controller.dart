import 'dart:math';

import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:plane/game/enemy_info.dart';
import 'package:plane/game/game_config.dart';
import 'package:plane/game/game_dialog.dart';
import 'package:plane/game/game_enemy.dart';
import 'package:plane/game/sound_controller.dart';

import 'game_hero.dart';

class GameController {
  ///
  factory GameController() => _getInstance();

  // 静态私有成员，没有初始化
  static GameController? _instance;

  // 静态、同步、私有访问点
  static GameController _getInstance() {
    _instance ??= GameController._internal();
    return _instance!;
  }

  // 私有构造函数
  GameController._internal() {}

  // 子弹的索引
  int planeIndex = 0;

  // 子弹的倍数
  final multipleList = [
    1,
    2,
    3,
    4,
    5,
    10,
    20,
    30,
    40,
    50,
    100,
    200,
    300,
    400,
    500,
    600,
    700,
    800,
    900,
    1000
  ];

  // 当前的分数
  int score = 1000;

  // 是否运行游戏
  bool isRunning = false;

  // 玩家对象
  late GameHero hero;

  // 敌机分数
  final planeScoreList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  // 敌机池
  final enemyList = <EnemyInfo>[];

  // 游戏控制对象
  late FlameGame game;

  // 主机位置
  late Vector2 heroPos;

  // 分数变化回调
  Function? onScoreChange;

  // 页面对象
  late BuildContext context;

  void setContent(BuildContext context) {
    this.context = context;
  }

  BuildContext getContent() {
    return context;
  }

  // 设置玩家位置
  void setHeroPos(Vector2 vector2) {
    heroPos = vector2;
  }

  // 设置游戏控制对象
  void setGame(FlameGame g) {
    game = g;
  }

  // 这是玩家对象
  void setHero(hero) {
    this.hero = hero;
  }

  // 创建敌机
  void createEnemy() async {
    // 游戏暂停时不生成
    if (isRunning) {
      if (enemyList.length < 3) {
        // 随机数判断生成敌机数据
        int total = 100;
        int index = 0;
        final temp = Random().nextInt(total);
        EnemyInfo enemyInfo = EnemyInfo();
        if (temp >= 97) {
          // 添加大灰机
          index = 8 + Random().nextInt(2);
          enemyInfo = GameConfig.enemyData[index];
        } else if (temp > 77 && temp < 97) {
          // 添加中灰机
          index = 6 + Random().nextInt(3);
          enemyInfo = GameConfig.enemyData[index];
        } else {
          // 添加小灰机
          index = Random().nextInt(6);
          enemyInfo = GameConfig.enemyData[index];
        }

        game.add(GameEnemy(
            enemyInfo: enemyInfo, multiple: multipleList[planeIndex]));

        enemyList.add(enemyInfo);
      }
    }

    // 如果不够3架飞机，就一直生成
    int duration = GameConfig.enemyCreateSpeed;
    if (enemyList.length <= 3) {
      duration = 0;
    }
    await Future.delayed(Duration(seconds: duration));

    createEnemy();
  }

  // 敌机爆炸💥后，在敌机池中去掉
  void removeEnemyData(enemy) {
    enemyList.remove(enemy);
  }

  // 敌机爆炸触发
  void onEnemyBoom(enemy) {
    final multiple = enemy["multiple"] as int;

    final planeScore = enemy["score"] as int;

    score += multiple * planeScore;

    if (onScoreChange != null) {
      onScoreChange!();
    }
  }

  // 玩家被大众后触发
  void onHeroHit(bullet) {
    final multiple = bullet["multiple"] as int;

    final planeScore = bullet["score"] as int;

    score -= multiple * planeScore;

    if (score <= 0) {
      score = 0;
      isRunning = false;

      game.add(GameDialog(onBack: () {}, type: 2));
    }

    if (onScoreChange != null) {
      onScoreChange!();
    }
  }

  // 设置分数监听器
  void setScoreChange(listener) {
    onScoreChange = listener;
  }

  // 停止游戏，停止生成，停止背景音乐，清除敌机池
  void stopGame() {
    SoundController().stopBg();
    isRunning = false;
    enemyList.clear();
  }

  // 开始游戏，设置状态，设置初始化分数，播放背景音乐，发射子弹，创建敌机
  void startGame() {
    isRunning = true;
    score = 1000;
    SoundController().playBg();
    hero.shoot();
    createEnemy();
  }
}
