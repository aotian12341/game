import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../game/game_view.dart';
import 'mahjong_view.dart';

class Mahjong extends StatefulWidget {
  const Mahjong({Key? key}) : super(key: key);

  @override
  State<Mahjong> createState() => _MahjongState();
}

class _MahjongState extends State<Mahjong> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenUtilInit(
        designSize: const Size(375, 800),
        minTextAdapt: true,
        splitScreenMode: true,
        child: Container(
          color: Colors.red,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: GameWidget(game: MahjongView(context: context)),
        ),
      ),
    );
  }
}
