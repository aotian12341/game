import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/cupertino.dart';
import 'package:plane/game/game_controller.dart';
import 'package:plane/game/image_assets.dart';

import 'game_config.dart';
import 'game_view.dart';

// 背景
class GameBg extends ParallaxComponent<GameView> {
  Function onBack;

  GameBg({required this.onBack});

  final layouts = <ParallaxLayer>[];

  @override
  Future<void> onLoad() async {
    // 随机数加载背景图
    var index = Random().nextInt(PlaneImages.bg.length);
    final bg = await Flame.images.load(PlaneImages.bg[index]);

    // final temp = await Flame.images.load("ui/bg/bg12.jpg");
    // final temp2 = await Flame.images.load("ui/bg/bg_12_item.png");

    size = game.size;

    layouts.add(ParallaxLayer(
        ParallaxImage(bg, repeat: ImageRepeat.repeatY, fill: LayerFill.width)));
    // layouts.add(ParallaxLayer(
    //     ParallaxImage(temp, repeat: ImageRepeat.repeatY, fill: LayerFill.width),
    //     velocityMultiplier: Vector2(0, 5)));
    // layouts.add(ParallaxLayer(
    //     ParallaxImage(temp2,
    //         repeat: ImageRepeat.repeatY, fill: LayerFill.width),
    //     velocityMultiplier: Vector2(0, 10)));

    parallax = Parallax(layouts, baseVelocity: Vector2(0, 5));

    priority = 0;
  }

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);
    // if (GameController().isRunning) {
    //   parallax?.baseVelocity.y = GameConfig.bgMoveSpeed;
    // } else {
    //   parallax?.baseVelocity.y = 0;
    // }
    // if ((parallax?.currentOffset().y ?? 0) >= 0.999) {
    //   onBack();
    // }

    // if (GameController().isRunning) {
    //   layouts[0].velocityMultiplier.y = 15;
    // } else {
    //   parallax?.baseVelocity.y = 0;
    // }
    // if ((parallax?.currentOffset().y ?? 0) >= 0.999) {
    //   onBack();
    // }
  }
}
