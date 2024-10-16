import 'package:flame/components.dart';

class EnemyInfo {
  // id
  int? id;
  // 生命
  int live = 1;
  // 飞机类型(大中小)
  int type = 1;
  // 倍数
  int score = 1;
  // 图片
  String imagePath = "";

  Vector2 size = Vector2(0, 0);

  static EnemyInfo create(data) {
    EnemyInfo info = EnemyInfo();
    info.id = data['id'];
    info.type = data['type'];
    info.score = data['score'];
    return info;
  }

  static String toJson(EnemyInfo data) {
    String res =
        "{\"id\":${data.id},\"type\":${data.type},\"score\":${data.score}}";
    return res;
  }
}
