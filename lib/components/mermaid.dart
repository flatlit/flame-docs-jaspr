import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';

/// Pass through Mermaid diagrams to be rendered on the clinet.
class Mermaid extends CustomComponent {
  Mermaid() : super.base();

  @override
  Component? create(Node node, NodesBuilder builder) {
    if (node case ElementNode(tag: 'pre', children: [ElementNode(tag: 'code', :final children, :final attributes)])) {
      var language = attributes['language'];
      if (language == null && (attributes['class']?.startsWith('language-') ?? false)) {
        language = attributes['class']!.substring('language-'.length);
      }

      if (language != 'mermaid' && language != '{mermaid}') {
        return null;
      }

      return _Mermaid(child: builder.build(children));
    }
    return null;
  }
}

class _Mermaid extends StatelessComponent {
  const _Mermaid({required this.child, super.key});

  final Component child;

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      Document.head(
        children: [
          script(
            id: 'mermaid-init',
            attributes: {'type': 'module'},
            content: '''
              import mermaid from 'https://cdn.jsdelivr.net/npm/mermaid@12/dist/mermaid.esm.min.mjs';
              mermaid.initialize({ startOnLoad: true, darkMode: true });''',
          ),
        ],
      ),
      pre(classes: 'mermaid', [child]),
    ]);
  }
}
