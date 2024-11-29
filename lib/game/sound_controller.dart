import 'dart:math';
import 'package:audioplayers/audioplayers.dart';

import 'package:plane/game/game_config.dart';

class SoundController {
  ///
  factory SoundController() => _getInstance();

  // 静态私有成员，没有初始化
  static SoundController? _instance;

  // 静态、同步、私有访问点
  static SoundController _getInstance() {
    _instance ??= SoundController._internal();
    return _instance!;
  }

  AudioPlayer? player;
  // List<AudioPlayer> shootList = [];
  // List<AudioPlayer> hitList = [];

  // 私有构造函数
  SoundController._internal() {
    init();
  }

  int shootIndex = 0;
  int hitIndex = 0;

  void init() {
    // boomPlayer = AudioPlayer();
    // shootPlayer = AudioPlayer();
    // boomPlayer.setSource(AssetSource("sounds/blast0.mp3"));
    // shootPlayer.setSource(AssetSource("sounds/planeshoot0.mp3"));
    // boomPlayer.setVolume(GameConfig.enemyBoomVolume);
    // shootPlayer.setVolume(GameConfig.heroBulletVolume);
    // for (var i = 0; i < 10; i++) {
    //   final temp = AudioPlayer();
    //   temp.setSource(AssetSource("sounds/planeshoot0.mp3"));
    //   temp.setVolume(GameConfig.heroBulletVolume / 2);
    //   shootList.add(temp);
    // }
    //
    // for (var i = 0; i < 20; i++) {
    //   final hit = AudioPlayer();
    //   hit.setSource(AssetSource("sounds/hero_hit.mp3"));
    //   hit.setVolume(GameConfig.heroBulletVolume / 2);
    //   hitList.add(hit);
    // }
  }

  void playBg() async {
    final bgList = [
      "sounds/gamebg0.mp3",
      "sounds/gamebg1.mp3",
      "sounds/menubg.mp3"
    ];
    final index = Random().nextInt(3);

    player = AudioPlayer();
    player!.stop();
    player!.setReleaseMode(ReleaseMode.loop);
    player!.play(AssetSource(bgList[index]), volume: GameConfig.bgMusicVolume);
  }

  void stopBg() {
    player?.stop();
  }

  void playBoom() {
    final temp = AudioPlayer();
    temp.play(
      AssetSource("sounds/blast0.mp3"),
      volume: GameConfig.heroBulletVolume,
    );
  }

  void playShoot() {
    final temp = AudioPlayer();
    temp
        .play(
      AssetSource("sounds/planeshoot0.mp3"),
      volume: GameConfig.heroBulletVolume,
    )
        .then((value) {
      // temp.release();
    });
    // temp.setSource(AssetSource("sounds/planeshoot0.mp3"));
    // temp.setVolume(GameConfig.heroBulletVolume / 2);
    // temp.resume();
    // shootList[shootIndex].resume();
    // shootIndex += 1;
    // if (shootIndex == shootList.length - 1) {
    //   shootIndex = 0;
    // }
    // if(shootIndex)
  }

  void playHeroHit() {
    final temp = AudioPlayer();
    temp.play(
      AssetSource("sounds/hero_hit.mp3"),
      volume: GameConfig.heroBulletVolume / 3,
    );
    // hitList[hitIndex].resume();
    // hitIndex += 1;
    //
    // if (hitIndex == hitList.length - 1) {
    //   hitIndex = 0;
    // }
    //
    // final hit = AudioPlayer();
    // hit.setSource(AssetSource("sounds/hero_hit.mp3"));
    // hit.setVolume(GameConfig.heroBulletVolume / 2);
    // if (hitIndex == 0) {
    //   hitList[hitList.length - 1].release();
    //   hitList[hitList.length - 1] = hit;
    // } else {
    //   hitList[hitIndex - 1].release();
    //   hitList[hitIndex - 1] = hit;
    // }
  }
}
