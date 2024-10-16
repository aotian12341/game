import 'package:flame/components.dart';
import 'package:flame/events.dart';

class SpriteBtn extends PositionComponent with TapCallbacks {
  SpriteBtn(
      {required this.pos,
      required this.s,
      required this.img,
      required this.onClick,
      this.spriteAngle});
  final Vector2 pos;
  final Vector2 s;
  final Sprite img;
  final double? spriteAngle;
  final Function onClick;

  @override
  Future<void> onLoad() async {
    size = s;
    position = pos;
    add(SpriteComponent(
      sprite: img,
      size: s,
    ));
    angle = spriteAngle ?? 0;
    anchor = spriteAngle == null ? Anchor.topLeft : Anchor.center;
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    onClick();
  }
}
