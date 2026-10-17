import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr/server.dart';
import 'package:jaspr_content/jaspr_content.dart';

/// A deprecation component
/// This is custom to the Flame documentation syntax.
class Deprecation extends CustomComponent {
  Deprecation() : super.base();

  @override
  Component? create(Node node, NodesBuilder builder) {
    if (node case ElementNode(tag: 'pre', children: [ElementNode(tag: 'code', :final children, :final attributes)])) {
      var language = attributes['language'];
      if (language == null && (attributes['class']?.startsWith('language-') ?? false)) {
        language = attributes['class']!.substring('language-'.length);
      }

      if (language != '{deprecated}') {
        return null;
      }

      final version = node.attributes['data-metadata'];
      return _Deprecation(version: version, child: builder.build(children));
    }
    return null;
  }

  @css
  static List<StyleRule> get styles => [
    css('.deprecated', [
      css('&').styles(display: Display.block),
      css('span:first-child').styles(fontStyle: FontStyle.italic),
    ]),
  ];
}

class _Deprecation extends StatelessComponent {
  const _Deprecation({required this.version, required this.child, super.key});

  final String? version;
  final Component child;

  @override
  Component build(BuildContext context) {
    return div(classes: 'deprecated', [
      span([Component.text(version != null ? 'Deprecated since version $version:' : 'Deprecated')]),
      child,
    ]);
  }
}
