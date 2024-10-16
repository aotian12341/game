import 'package:flame/events.dart';
import 'dart:async';

import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:plane/game/game_bg.dart';
import 'package:plane/game/game_bullet_controller.dart';
import 'package:plane/game/game_controller.dart';
import 'package:plane/game/game_score.dart';

import 'game_dialog.dart';
import 'game_hero.dart';
import 'game_plane_btn.dart';
import 'game_state_btn.dart';

// 游戏组件
class GameView extends FlameGame
    with HasCollisionDetection, TapCallbacks, DragCallbacks {
  // 玩家飞机
  final hero = GameHero();

  // 右上角分数
  late GameScore score;

  // 当前页面实例
  final BuildContext context;

  GameView({required this.context});

  // 背景图片数组(后来说不需要改变背景，暂时用不上)
  final List<GameBg> bgList = [];

  // 游戏背景
  late GameBg bg;

  @override
  Future<void> onLoad() async {
    score = GameScore();

    bg = GameBg(onBack: initBg);

    addAll([
      bg,
      hero,
      // 右下角子弹控制器
      GamePlaneBtn(onIndexChange: () {
        // 变化时更新飞机ui
        hero.planeChange();
      }),
      // 分数
      score,
      // 左上角按钮
      GameStateBtn(),
      // 弹窗对话框type=0开始游戏，type=1暂停，type=2，没有分了要充值
      GameDialog(onBack: () {}, type: 0)
    ]);

    // 设置页面实例(用于退出页面)
    GameController().setContent(context);
    // 设置游戏实例(用于添加敌机、子弹)
    GameController().setGame(this);
    // 开始游戏
    GameBulletController().setGame(this);
    // 设置玩家飞机实例
    GameController().setHero(hero);
    // 设置分数变化监听，更新分数
    GameController().setScoreChange(() {
      score.updateScore();
    });

    return super.onLoad();
  }

  // 变更图片背景，弃用
  void initBg() {
    // bg.removeFromParent();
    // bg = GameBg(onBack: initBg);
    // add(bg);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    // 手指拖拽，移动主机
    hero.move(event.localEndPosition);
  }

  @override
  void onTapDown(TapDownEvent event) {}
}
