import 'dart:convert';
import 'dart:math';

import 'enemy_info.dart';
import 'game_config.dart';

class GameServer {
  factory GameServer() => _getInstance();

  // 静态私有成员，没有初始化
  static GameServer? _instance;

  // 静态、同步、私有访问点
  static GameServer _getInstance() {
    _instance ??= GameServer._internal();
    return _instance!;
  }

  // 敌机池
  final enemyList = <EnemyInfo>[];

  // 敌机分数
  final planeScoreList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  int count = 0;

  // 私有构造函数
  GameServer._internal() {
    countDown();
  }

  void countDown() {
    Future.delayed(const Duration(seconds: 2), () {
      count += 1;
      shootBig();
      countDown();
    });
  }

  void enterRoom() {
    gameStart();
  }

  void gameStart() {
    createEnemy();
  }

  // 创建敌机
  void createEnemy() async {
    // 游戏暂停时不生成

    if (enemyList.length < 3) {
      // 随机数判断生成敌机数据
      int total = 100;
      int index = 0;
      int id = DateTime.now().millisecondsSinceEpoch;
      index = Random().nextInt(GameConfig.enemyData.length);
      EnemyInfo enemyInfo = GameConfig.enemyData[index];
      enemyInfo.id = id;

      enemyList.add(enemyInfo);

      sendMessage("createEnemy", EnemyInfo.toJson(enemyInfo));

      createEnemy();
    }
  }

  // 放巡航导弹
  void shootBig() {
    final temp = Random().nextInt(100);
    if (enemyList.isNotEmpty) {
      if (temp >= 90) {
        sendMessage("shoot", json.encode({}));
      }
    }
  }

  // 击中敌机时
  void shootEnemy(data) {
    const total = 1000;
    final temp = Random().nextInt(total);

    if (temp >= 990) {
      sendMessage(
          "boom", json.encode({"id": data['id'], 'score': data['score']}));
      // 敌机爆炸了之后清除池子，创建新的
      for (final item in enemyList) {
        if (item.id == data['id']) {
          enemyList.remove(item);
          break;
        }
      }
      createEnemy();
    }
  }

  // 被击中时
  void onHit(data) {
    sendMessage("hit", json.encode({"score": data['score']}));
  }

  late Function callBack;
  void messageBack(callBack) {
    this.callBack = callBack;
  }

  // 发送消息
  void sendMessage(type, data) {
    var res = {"type": type, "data": data};
    callBack(json.encode(res));
  }
}
