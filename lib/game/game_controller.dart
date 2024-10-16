import 'dart:convert';

import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:plane/game/enemy_info.dart';
import 'package:plane/game/game_config.dart';
import 'package:plane/game/game_dialog.dart';
import 'package:plane/game/game_enemy.dart';
import 'package:plane/game/game_server.dart';
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
  GameController._internal() {
    GameServer().messageBack(onMessageBack);
  }

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
  final enemyList = <GameEnemy>[];

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
  void createEnemy(EnemyInfo enemyInfo) async {
    final enemy =
        GameEnemy(enemyInfo: enemyInfo, multiple: multipleList[planeIndex]);
    enemyList.add(enemy);
    game.add(enemy);
  }

  // 敌机爆炸💥后，在敌机池中去掉
  void removeEnemyData(enemy) {
    enemyList.remove(enemy);
  }

  // 敌机爆炸触发
  void onEnemyBoom(enemy) {
    GameServer().shootEnemy(enemy);
  }

  // 玩家被打中后触发
  void onHeroHit(bullet) {
    final multiple = bullet["multiple"] as int;

    final planeScore = bullet["score"] as int;

    GameServer().onHit({"score": planeScore * multiple});
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
    // createEnemy();

    // 进入游戏
    GameServer().enterRoom();
  }

  // 消息监听
  void onMessageBack(value) {
    final data = json.decode(value);
    if (data['type'] == "createEnemy") {
      final str = json.decode(data['data']);
      final enemy = EnemyInfo.create(str);
      EnemyInfo info = EnemyInfo();
      for (final item in GameConfig.enemyData) {
        if (item.type == enemy.type) {
          info = item;
          info.id = enemy.id;
        }
      }
      createEnemy(info);
    } else if (data['type'] == 'boom') {
      final info = json.decode(data['data']);
      for (final enemy in enemyList) {
        if (info['id'] == enemy.enemyInfo.id) {
          if (!enemy.isDeath) {
            enemy.boom();
          }
        }
      }
    } else if (data['type'] == 'hit') {
      final info = json.decode(data['data']);
      final scoreBack = info['score'] as int;

      score -= scoreBack;

      if (score <= 0) {
        score = 0;
        isRunning = false;

        game.add(GameDialog(onBack: () {}, type: 2));
      }

      if (onScoreChange != null) {
        onScoreChange!();
      }
    } else if (data['type'] == 'shoot') {
      for (final enemy in enemyList) {
        enemy.shootBig();
      }
    } else if (data['type'] == 'charge') {}
  }
}
