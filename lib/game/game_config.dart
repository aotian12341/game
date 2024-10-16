import 'package:flame/components.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:plane/game/image_assets.dart';

import 'enemy_info.dart';

class GameConfig {
  // 敌机飞行速度
  static double enemyMoveSpeed = 40;

  // 敌机子弹生成速度
  static int enemyBulletCreateSpeed = 2000;

  // 敌机普通子弹速度
  static int enemyBulletSpeed = 200;

  // 敌机大招速度
  static double enemyBulletBigSpeed = 1200;

  // 主机子弹生成速度
  static int heroBulletCreateSpeed = 200;

  // 主机子弹速度
  static int heroBulletSpeed = 600;

  // 敌机生成速度
  static int enemyCreateSpeed = 5;

  // 背景移动速度
  static double bgMoveSpeed = 10;

  // 背景音乐声音大小
  static double bgMusicVolume = 0.2;

  // 敌机爆炸声音大小
  static double enemyBoomVolume = 1.0;

  // 主机子弹声音大小
  static double heroBulletVolume = 1.0;

  // 梅花子弹速度
  static int enemyBulletSnowSpeed = 400;

  // 梅花子弹生成速度
  static int enemyBulletSnowCreateSpeed = 2000;

  static List<EnemyInfo> enemyData = [
    EnemyInfo()
      ..live = 30
      ..type = 0
      ..score = 1
      ..imagePath = PlaneImages.enemy[0]
      ..size = Vector2(125.w, 100.w),
    EnemyInfo()
      ..live = 25
      ..type = 1
      ..score = 1
      ..imagePath = PlaneImages.enemy[1]
      ..size = Vector2(166.w, 70.w),
    EnemyInfo()
      ..live = 30
      ..type = 2
      ..score = 1
      ..imagePath = PlaneImages.enemy[2]
      ..size = Vector2(146.w, 60.w),
    EnemyInfo()
      ..live = 20
      ..type = 3
      ..score = 1
      ..imagePath = PlaneImages.enemy[3]
      ..size = Vector2(150.w, 100.w),
    EnemyInfo()
      ..live = 25
      ..type = 4
      ..score = 1
      ..imagePath = PlaneImages.enemy[4]
      ..size = Vector2(150.w, 75.w),
    EnemyInfo()
      ..live = 15
      ..type = 5
      ..score = 1
      ..imagePath = PlaneImages.enemy[5]
      ..size = Vector2(112.w, 60.w),
    EnemyInfo()
      ..live = 20
      ..type = 6
      ..score = 1
      ..imagePath = PlaneImages.enemy[6]
      ..size = Vector2(126.w, 100.w),
    EnemyInfo()
      ..live = 10
      ..type = 7
      ..score = 1
      ..imagePath = PlaneImages.enemy[7]
      ..size = Vector2(133.w, 111.w),
    EnemyInfo()
      ..live = 20
      ..type = 8
      ..score = 1
      ..imagePath = PlaneImages.enemy[8]
      ..size = Vector2(137.w, 100.w),
    EnemyInfo()
      ..live = 10
      ..type = 9
      ..score = 1
      ..imagePath = PlaneImages.enemy[9]
      ..size = Vector2(138.w, 102.w),
  ];
}
