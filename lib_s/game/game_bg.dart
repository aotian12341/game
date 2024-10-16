import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/cupertino.dart';
import 'package:plane/game/image_assets.dart';

import 'game_view.dart';

class GameBg extends ParallaxComponent<GameView> {
  List<ParallaxLayer> layouts = [];

  int bgIndex = 0;

  Function onBack;

  GameBg({required this.onBack});

  @override
  Future<void> onLoad() async {
    var index = Random().nextInt(PlaneImages.bg.length);

    final bg = await Flame.images.load(PlaneImages.bg[index]);
    final item = await Flame.images.load(PlaneImages.bgItems[index]);

    final wu = await Flame.images.load("ui/bg/game_bg_wu.png");

    size = game.size;

    // 目前是可以的
    parallax = Parallax([
      ParallaxLayer(
          ParallaxImage(bg, repeat: ImageRepeat.repeatY, fill: LayerFill.width),
          velocityMultiplier: Vector2(0, -5)),
      ParallaxLayer(
          ParallaxImage(item,
              repeat: ImageRepeat.repeatY,
              fill: index == 3 ? LayerFill.height : LayerFill.width),
          velocityMultiplier: Vector2(index == 3 ? -10 : 0, -10)),
      ParallaxLayer(
          ParallaxImage(wu, repeat: ImageRepeat.repeatY, fill: LayerFill.width),
          velocityMultiplier: Vector2(0, -20))
    ], baseVelocity: Vector2(0, 5));

    priority = 0;
  }

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);
    // print(parallax?.currentOffset());
    // if (GameController().isRunning) {
    //   parallax?.baseVelocity.y = GameConfig.bgMoveSpeed;
    // } else {
    //   parallax?.baseVelocity.y = 0;
    // }
    // if ((parallax?.currentOffset().y ?? 0) >= 0.999) {
    //   onBack();
    //   // parallax?.layers.removeAt(layouts.length - 1);
    //   // bgIndex += 1;
    //   // if (bgIndex == layouts.length - 1) {
    //   //   bgIndex = 0;
    //   // }
    //   // parallax?.layers.add(layouts[bgIndex]);
    // }
  }
}
