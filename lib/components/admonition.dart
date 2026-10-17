import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr/server.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' show CornerUpRight, Info, TriangleAlert, Bug;

/// A admonitions component that renders a callout.
/// This is custom to the Flame documentaiton syntax.
class Admonition extends CustomComponent {
  Admonition() : super.base();

  @override
  Component? create(Node node, NodesBuilder builder) {
    if (node case ElementNode(tag: 'pre', children: [ElementNode(tag: 'code', :final children, :final attributes)])) {
      var language = attributes['language'];
      if (language == null && (attributes['class']?.startsWith('language-') ?? false)) {
        language = attributes['class']!.substring('language-'.length);
      }

      if (language != '{note}' && language != '{warning}' && language != '{error}' && language != '{seealso}') {
        return null;
      }

      var type = language ?? '{note}';
      type = type.substring(1, type.length - 1);
      return _Admonition(type: type, child: builder.build(children));
    }
    return null;
  }

  @css
  static List<StyleRule> get styles => [
    css('.admonition', [
      css('&').styles(
        display: Display.flex,
        padding: Padding.symmetric(vertical: 0.5.rem, horizontal: 0.5.rem),
        margin: Margin.only(bottom: 0.75.rem),
        radius: BorderRadius.all(Radius.circular(5.px)),
        flexDirection: FlexDirection.row,
        alignItems: AlignItems.start,
        gap: Gap.column(0.75.rem),
      ),
      css('&.admonition-note').styles(
        border: Border.only(
          left: BorderSide.solid(color: Color('#6eb1cc'), width: 3.px),
        ),
        backgroundColor: Color('#235179'),
      ),
      css('&.admonition-warning').styles(
        border: Border.only(
          left: BorderSide.solid(color: Color('orange'), width: 3.px),
        ),
        backgroundColor: Color('#a16820'),
      ),
      css('&.admonition-error').styles(
        border: Border.only(
          left: BorderSide.solid(color: Color('red'), width: 3.px),
        ),
        backgroundColor: Color('#460202'),
      ),
      css('&.admonition-seealso').styles(
        border: Border.only(
          left: BorderSide.solid(color: Color('#54d452'), width: 3.px),
        ),
        backgroundColor: Color('#28513140'),
      ),
    ]),
    css('&.admonition-icon').styles(
      flex: Flex(shrink: 0),
    ),
    css('&.admonition-title').styles(
      flex: Flex(shrink: 0),
      fontWeight: FontWeight.bold,
    ),
    css('&.admonition-body').styles(
      display: Display.flex,
      flexDirection: FlexDirection.column,
      gap: Gap.all(1.rem),
    ),
  ];
}

class _Admonition extends StatelessComponent {
  const _Admonition({required this.type, required this.child, super.key});

  final String type;
  final Component child;

  @override
  Component build(BuildContext context) {
    return div(classes: 'admonition admonition-$type', [
      div(classes: "admonition-icon", [
        switch (type) {
          'note' => Info(),
          'warning' => TriangleAlert(),
          'error' => Bug(),
          'seealso' => CornerUpRight(),
          _ => Info(),
        },
      ]),
      div(classes: "admonition-body", [
        span(classes: "admonition-title", [
          switch (type) {
            'note' => Component.text("Note"),
            'warning' => Component.text("Warning"),
            'error' => Component.text("Error"),
            'seealso' => Component.text("Also see"),
            _ => Component.text("Note"),
          },
        ]),
        span([child]),
      ]),
    ]);
  }
}
