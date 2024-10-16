import 'package:flame/events.dart';
import 'dart:async';

import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:plane/game/game_bg.dart';
import 'package:plane/game/game_bullet_controller.dart';
import 'package:plane/game/game_controller.dart';
import 'package:plane/game/game_score.dart';
import 'package:plane/game/game_sprite_btn.dart';

import 'game_dialog.dart';
import 'game_hero.dart';
import 'game_plane_btn.dart';
import 'game_state_btn.dart';

class GameView extends FlameGame
    with HasCollisionDetection, TapCallbacks, DragCallbacks {
  final hero = GameHero();
  late GameScore score;

  final BuildContext context;

  GameView({required this.context});

  final List<GameBg> bgList = [];
  late GameBg bg;

  @override
  Future<void> onLoad() async {
    score = GameScore();

    bg = GameBg(onBack: initBg);

    addAll([
      bg,
      hero,
      GamePlaneBtn(onIndexChange: () {
        hero.planeChange();
      }),
      score,
      GameStateBtn(),
      GameDialog(onBack: () {}, type: 0)
    ]);

    GameController().setContent(context);
    GameController().setGame(this);
    GameBulletController().setGame(this);
    GameController().setHero(hero);

    GameController().setScoreChange(() {
      score.updateScore();
    });

    return super.onLoad();
  }

  void initBg() {
    // bg.removeFromParent();
    // bg = GameBg(onBack: initBg);
    // add(bg);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    hero.move(event.localEndPosition);
  }

  @override
  void onTapDown(TapDownEvent event) {}
}
