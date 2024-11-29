import 'package:flame/events.dart';
import 'dart:async';

import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';

class MahjongView extends FlameGame
    with HasCollisionDetection, TapCallbacks, DragCallbacks {
  final BuildContext context;

  MahjongView({required this.context});

  @override
  Future<void> onLoad() async {
    return super.onLoad();
  }
}
