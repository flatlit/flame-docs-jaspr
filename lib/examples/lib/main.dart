import './anchor.dart';
import './anchor_by_effect.dart';
import './anchor_to_effect.dart';
import './collision_detection.dart';
import './color_effect.dart';
import './decorator_blur.dart';
import './decorator_grayscale.dart';
import './decorator_hue.dart';
import './decorator_rotate3d.dart';
import './decorator_shadow3d.dart';
import './decorator_tint.dart';
import './drag_events.dart';
import './glow_effect.dart';
import './hue_effect.dart';
import './move_along_path_effect.dart';
import './move_by_effect.dart';
import './move_to_effect.dart';
import './opacity_by_effect.dart';
import './opacity_effect_with_target.dart';
import './opacity_to_effect.dart';
import './pointer_events.dart';
import './post_process.dart';
import './ray_cast.dart';
import './ray_trace.dart';
import './remove_effect.dart';
import './rive_example.dart';
import './rotate_around_effect.dart';
import './rotate_by_effect.dart';
import './rotate_to_effect.dart';
import './router.dart';
import './scale_by_effect.dart';
import './scale_to_effect.dart';
import './sequence_effect.dart';
import './size_by_effect.dart';
import './size_to_effect.dart';
import './tap_events.dart';
import './time_scale.dart';
import './value_route.dart';
import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:web/web.dart' as web;

final routes = <String, Game Function()>{
  'anchor': AnchorGame.new,
  'anchor_by_effect': AnchorByEffectGame.new,
  'anchor_to_effect': AnchorToEffectGame.new,
  'collision_detection': CollisionDetectionGame.new,
  'color_effect': ColorEffectExample.new,
  'decorator_blur': DecoratorBlurGame.new,
  'decorator_grayscale': DecoratorGrayscaleGame.new,
  'decorator_hue': DecoratorHueGame.new,
  'decorator_rotate3d': DecoratorRotate3DGame.new,
  'decorator_shadow3d': DecoratorShadowGame.new,
  'decorator_tint': DecoratorTintGame.new,
  'drag_events': DragEventsGame.new,
  'glow_effect': GlowEffectExample.new,
  'hue_effect': HueEffectExample.new,
  'move_along_path_effect': MoveAlongPathEffectGame.new,
  'move_by_effect': MoveByEffectGame.new,
  'move_to_effect': MoveToEffectGame.new,
  'opacity_by_effect': OpacityByEffectGame.new,
  'opacity_effect_with_target': OpacityEffectWithTargetGame.new,
  'opacity_to_effect': OpacityToEffectGame.new,
  'pointer_events': PointerEventsGame.new,
  'post_process': PostProcessGame.new,
  'ray_cast': RayCastExample.new,
  'ray_trace': RayTraceExample.new,
  'remove_effect': RemoveEffectGame.new,
  'rive_example': RiveExampleGame.new,
  'rotate_around_effect': RotateAroundEffectGame.new,
  'rotate_by_effect': RotateByEffectGame.new,
  'rotate_to_effect': RotateToEffectGame.new,
  'router': RouterGame.new,
  'scale_by_effect': ScaleByEffectGame.new,
  'scale_to_effect': ScaleToEffectGame.new,
  'sequence_effect': SequenceEffectGame.new,
  'size_by_effect': SizeByEffectGame.new,
  'size_to_effect': SizeToEffectGame.new,
  'tap_events': TapEventsGame.new,
  'time_scale': TimeScaleGame.new,
  'value_route': ValueRouteExample.new,
};

void main() {
  var page = web.window.location.search;
  if (page.startsWith('?')) {
    page = page.substring(1);
  }
  final game = routes[page]?.call();
  if (game != null) {
    runApp(GameWidget(game: game));
  } else {
    runApp(_IndexRoute(page: page));
  }
}

class const _IndexRoute({
  required final String page,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        children: [
          Text('Error: unknown page name "$page"'),
          const Text('Select an option below:'),
          ...routes.keys.map((route) {
            return GestureDetector(
              onTap: () => web.window.location.replace('/?$route'),
              child: Text(route),
            );
          }),
        ],
      ),
    );
  }
}
