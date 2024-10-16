import 'package:flame/components.dart';
import 'package:flame/events.dart';

// 精灵图按钮
class SpriteBtn extends PositionComponent with TapCallbacks {
  SpriteBtn(
      {required this.pos,
      required this.s,
      required this.img,
      required this.onClick,
      this.spriteAngle});
  // 位置
  final Vector2 pos;
  // 大小
  final Vector2 s;
  // 图片
  final Sprite img;
  // 角度，当角度不为空，设置组件锚点在图片中心位置
  final double? spriteAngle;
  // 点击回调
  final Function onClick;

  @override
  Future<void> onLoad() async {
    size = s;
    position = pos;
    add(SpriteComponent(
      sprite: img,
      size: s,
    ));
    //当角度不为空，设置组件锚点在图片中心位置
    angle = spriteAngle ?? 0;
    anchor = spriteAngle == null ? Anchor.topLeft : Anchor.center;
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    onClick();
  }
}
