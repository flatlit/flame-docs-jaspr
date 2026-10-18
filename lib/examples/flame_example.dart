import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_flutter_embed/jaspr_flutter_embed.dart';

@Import.onWeb('package:flame/game.dart', show: [#GameWidget])
@Import.onWeb('lib/anchor_to_effect.dart', show: [#AnchorToEffectGame])
@Import.onWeb('lib/anchor_by_effect.dart', show: [#AnchorByEffectGame])
import 'flame_example.imports.dart';

/// Embedded a Flame Example into Markdown
/// with <FlameExample page="anchor_to_effect" />
@client
class FlameExample extends StatelessComponent {
  const FlameExample({required this.page, super.key});

  // this is named after the flutter-app directive 'page'
  final String page;

  @override
  Component build(BuildContext context) {
    return .fragment([
      Document.head(
        children: [
          script(src: '/flutter_bootstrap.js', async: true, id: 'flutter-bootstrap'),
        ],
      ),
      FlutterEmbedView(
        widget: !kIsWeb
            ? null
            : GameWidget(
                game: switch (page) {
                  "anchor_to_effect" => AnchorToEffectGame(),
                  "anchor_by_effect" => AnchorByEffectGame(),
                  _ => throw ArgumentError.value(page, 'page', "unknown example"),
                },
              ),
        constraints: ViewConstraints(
          minWidth: 160,
          minHeight: 120,
          maxWidth: 640,
          maxHeight: 480,
        ),
      ),
    ]);
  }
}
