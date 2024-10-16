import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'game_view.dart';

class PlanePage extends StatefulWidget {
  const PlanePage({Key? key}) : super(key: key);

  @override
  State<PlanePage> createState() => _PlanePageState();
}

class _PlanePageState extends State<PlanePage> {
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
          child: GameWidget(game: GameView(context: context)),
        ),
      ),
    );
  }
}
