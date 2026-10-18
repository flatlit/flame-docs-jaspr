import 'package:jaspr/jaspr.dart';
import 'package:jaspr/server.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:jaspr_poc/examples/flame_example.dart';

/// A flutter-app component
/// This is custom to the Flame documentation syntax.
class FlutterApp extends CustomComponent {
  FlutterApp() : super.base();

  @override
  Component? create(Node node, NodesBuilder builder) {
    if (node case ElementNode(tag: 'pre', children: [ElementNode(tag: 'code', :final children, :final attributes)])) {
      var language = attributes['language'];
      if (language == null && (attributes['class']?.startsWith('language-') ?? false)) {
        language = attributes['class']!.substring('language-'.length);
      }

      if (language != '{flutter-app}') {
        return null;
      }

      final params = Parameters.parse(children?.map((c) => c.innerText).join(" ") ?? '');

      // TODO ignoring rest of params
      return FlameExample(page: params.page ?? 'missing');
    }
    return null;
  }
}

class Parameters {
  final String? sources;
  final String? page;
  final List<String>? show;
  final int? width;
  final int? height;

  const Parameters({
    this.sources,
    this.page,
    this.show,
    this.width,
    this.height,
  });

  static final _directiveRegex = RegExp(r'^:([\w-]+):\s*(.*)$');

  factory Parameters.parse(String body) {
    final map = <String, String>{};
    for (final line in body.split('\n')) {
      final match = _directiveRegex.firstMatch(line.trim());
      if (match != null) {
        map[match.group(1)!] = match.group(2)!.trim();
      }
    }

    return Parameters(
      sources: map['sources'],
      page: map['page'],
      show: map['show']?.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList(),
      width: int.tryParse(map['width'] ?? ''),
      height: int.tryParse(map['height'] ?? ''),
    );
  }
}
