/// The entrypoint for the **server** environment.
///
/// The [main] method will only be executed on the server during pre-rendering.
/// To run code on the client, check the `main.client.dart` file.
library;

// Server-specific Jaspr import.

import 'dart:convert';

import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import 'package:jaspr_content/components/code_block.dart';
import 'package:jaspr_content/components/github_button.dart';
import 'package:jaspr_content/components/header.dart';
import 'package:jaspr_content/components/image.dart';
import 'package:jaspr_content/components/sidebar.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:jaspr_content/theme.dart';
import 'package:flame_docs_jaspr/components/admonition.dart';
import 'package:flame_docs_jaspr/components/deprecation.dart';
import 'package:flame_docs_jaspr/components/flutter_app.dart';
import 'package:flame_docs_jaspr/components/mermaid.dart';
import 'package:flame_docs_jaspr/examples/flame_example.dart';
import 'package:jaspr_router/jaspr_router.dart';

// This file is generated automatically by Jaspr, do not remove or edit.
import 'main.server.options.dart';

// An 'no syntax' highligher which we can use as we migration from directives
final emptyGrammar = jsonEncode(const <String, Object?>{
  'name': 'directive',
  'scopeName': 'text.plain',
  'patterns': <Object?>[],
});

// Theme
final primaryColor = Color("#ff9500");
final backgroundColor = Color("#383838");
final textColor = Color("#cccccc");
final preBgColor = Color("#202020");
final codeColor = Color("#8b9fb1");
final linkColor = Color("#ff9500");

final linkStyles = Styles(color: linkColor);
final headerLinkStyles = Styles(
  padding: Spacing.fromLTRB(Unit.em(0.5), Unit.zero, Unit.em(0.5), Unit.zero),
  alignSelf: AlignSelf.center,
  color: textColor,
);

void main() {
  // Initializes the server environment with the generated default options.
  Jaspr.initializeApp(
    options: defaultServerOptions,
  );

  // Our content director has asset in
  final assetManager = AssetManager(
    // The root directory where your assets are located. Usually, this is the same as your content directory.
    directory: 'content',
    // Optional: Configure which properties in your frontmatter contain asset paths.
    // dataProperties: {'image', 'meta.thumbnail'},
  );
  ServerApp.addMiddleware(assetManager.middleware);

  // Starts the app.
  //
  // [ContentApp] spins up the content rendering pipeline from jaspr_content to render
  // your markdown files in the content/ directory to a beautiful documentation site.
  runApp(
    ContentApp.custom(
      loaders: [
        FilesystemLoader('content', filterExtensions: {".md"}),
      ],
      configResolver: PageConfig.all(
        dataLoaders: [
          FilesystemDataLoader("content/_data"),
          assetManager.dataLoader,
        ],
        // Enables mustache templating inside the markdown files.
        templateEngine: MustacheTemplateEngine(),
        parsers: [
          MarkdownParser(),
        ],
        extensions: [
          // Adds heading anchors to each heading.
          HeadingAnchorsExtension(),
          // Generates a table of contents for each page.
          TableOfContentsExtension(),
          assetManager.pageExtension,
        ],
        components: [
          CustomComponent(
            pattern: 'FlameExample',
            builder: (name, attributes, child) {
              return FlameExample(page: attributes["page"] ?? "missing");
            },
          ),

          // Direcctives
          FlutterApp(),
          Mermaid(),
          Deprecation(),
          Admonition(),
          // Adds syntax highlighting to code blocks.
          CodeBlock(
            defaultLanguage: 'dart',
            grammars: {
              // These are directives used by Sphinx
              '{include}': emptyGrammar, // TODO there are rarely used, they should be inlined
              '{toctree}': emptyGrammar, // TODO we need a new way to create the sidebar
              // Handled by Admonition component
              // '{note}': emptyGrammar,
              // '{warning}': emptyGrammar,
              // '{error}': emptyGrammar,
              // '{seealso}': emptyGrammar,
              // Handled by Deprecation component
              // '{deprecated}': emptyGrammar,
              // Handled by Mermaid component
              // '{mermaid}': emptyGrammar,
              // Handled by FlutterApp component
              // '{flutter-app}': emptyGrammar,
              // TODO suggest these just link to the API doc
              '{dartdoc}': emptyGrammar,
              // TODO sphinx thing?
              '{list-table}': emptyGrammar,
              // Languages (to be rationalised and additional )
              'xml': emptyGrammar,
              'bash': emptyGrammar,
              'sh': emptyGrammar,
              'shell': emptyGrammar,
              'console': emptyGrammar,
              'markdown': emptyGrammar,
              'text': emptyGrammar,
              'yaml': emptyGrammar,
              'yarn': emptyGrammar,
              'glsl': emptyGrammar,
            },
          ),
          // Adds zooming and caption support to images.
          Image(zoom: true),
        ],
        layouts: [
          DocsLayout(
            header: Header(
              // Logo has FLAME already
              title: 'Documentation',
              logo: '/images/logo_flame.png',

              items: [
                Link(
                  child: Component.text("API"),
                  to: "https://pub.dev/documentation/flame/latest/",
                  styles: headerLinkStyles,
                ),
                Link(
                  child: Component.text("Examples"),
                  to: 'https://examples.flame-engine.org/',
                  styles: headerLinkStyles,
                ),
                Link(
                  child: Component.text("Discord"),
                  to: 'https://discord.com/invite/pxrBmy4',
                  styles: headerLinkStyles,
                ),
                // Shows github stats.
                GitHubButton(repo: 'flame-engine/flame'),
              ],
            ),
            footer: footer([
              small([
                Component.text("The content on this page is licensed under the"),
                a(href: "https://creativecommons.org/licenses/by/4.0/", styles: linkStyles, [
                  Component.text("CC BY 4.0 License"),
                ]),
                Component.text("  and code samples under the"),
                a(href: "https://raw.githubusercontent.com/flame-engine/flame/main/LICENSE", styles: linkStyles, [
                  Component.text("MIT License."),
                ]),
              ]),
            ]),
            sidebar: Sidebar(
              groups: [
                // Adds navigation links to the sidebar.
                SidebarGroup(
                  links: [
                    SidebarLink(text: "Index", href: '/'),
                    SidebarLink(text: "README", href: '/README'),
                  ],
                ),
                SidebarGroup(
                  title: "Basics",
                  links: [
                    SidebarLink(text: "Flame", href: '/flame/flame'),
                    SidebarLink(text: "Camera", href: '/flame/camera'),
                    SidebarLink(text: "Collisions", href: '/flame/collision_detection'),
                    SidebarLink(text: "Game Widget", href: '/flame/game_widget'),
                    SidebarLink(text: "Game", href: '/flame/game'),
                    SidebarLink(text: "Migration", href: '/flame/migration'),
                    SidebarLink(text: "Overlays", href: '/flame/overlays'),
                    SidebarLink(text: "Platforms", href: '/flame/platforms'),
                    SidebarLink(text: "Router", href: '/flame/router'),
                    SidebarLink(text: "Structure", href: '/flame/structure'),
                  ],
                ),
                SidebarGroup(
                  title: "Components",
                  links: [
                    SidebarLink(text: "Components", href: '/flame/components/components'),
                    SidebarLink(text: "Parallax", href: '/flame/components/parallax_component'),
                    SidebarLink(text: "Position", href: '/flame/components/position_component'),
                    SidebarLink(text: "Shapes", href: '/flame/components/shape_components'),
                    SidebarLink(text: "Sprites", href: '/flame/components/sprite_components'),
                    SidebarLink(text: "Utilities", href: '/flame/components/utility_components'),
                  ],
                ),
                SidebarGroup(
                  title: "Effects",
                  links: [
                    SidebarLink(text: "Effects", href: '/flame/effects/effects'),
                    SidebarLink(text: "Anchor", href: '/flame/effects/anchor_effects'),
                    SidebarLink(text: "Color", href: '/flame/effects/color_effects'),
                    SidebarLink(text: "Combined", href: '/flame/effects/combined_effect'),
                    SidebarLink(text: "Effect Controllers", href: '/flame/effects/effect_controllers'),
                    SidebarLink(text: "Function", href: '/flame/effects/function_effect'),
                    SidebarLink(text: "Move", href: '/flame/effects/move_effects'),
                    SidebarLink(text: "Remove", href: '/flame/effects/remote_effect'),
                    SidebarLink(text: "Rotate", href: '/flame/effects/rotate_effects'),
                    SidebarLink(text: "Scale", href: '/flame/effects/scale_effects'),
                    SidebarLink(text: "Sequence", href: '/flame/effects/sequence_effect'),
                    SidebarLink(text: "Size", href: '/flame/effects/size_effects'),
                    SidebarLink(text: "Warp", href: '/flame/effects/warp_effects'),
                  ],
                ),
                SidebarGroup(
                  title: "Inputs",
                  links: [
                    SidebarLink(text: "Inputs", href: '/flame/inputs/inputs'),
                    SidebarLink(text: "Drag events", href: '/flame/inputs/drag_events'),
                    SidebarLink(
                      text: "Hardware Keyboard Detector",
                      href: '/flame/inputs/hardware_keyboard_detector',
                    ),
                    SidebarLink(text: "Keyboard input", href: '/flame/inputs/keyboard_input'),
                    SidebarLink(text: "Long Press events", href: '/flame/inputs/long_press_events'),
                    SidebarLink(text: "Other inputs", href: '/flame/inputs/other_inputs'),
                    SidebarLink(text: "Pointer events", href: '/flame/inputs/pointer_events'),
                    SidebarLink(text: "Scale events", href: '/flame/inputs/scale_events'),
                    SidebarLink(text: "Tap events", href: '/flame/inputs/tap_events'),
                  ],
                ),
                SidebarGroup(
                  title: "Layouts",
                  links: [
                    SidebarLink(text: "Layout", href: '/flame/layout/layout'),
                    SidebarLink(text: "Align", href: '/flame/layout/align_component'),
                    SidebarLink(text: "Column", href: '/flame/layout/column_component'),
                    SidebarLink(text: "Expanded", href: '/flame/layout/expanded_component'),
                    SidebarLink(text: "Padding", href: '/flame/layout/padding_component'),
                    SidebarLink(text: "Row", href: '/flame/layout/row_component'),
                  ],
                ),
                SidebarGroup(
                  title: "Other",
                  links: [
                    SidebarLink(text: "Other", href: '/flame/other/other'),
                    SidebarLink(text: "CLI", href: '/flame/other/cli'),
                    SidebarLink(text: "Debug", href: '/flame/other/debug'),
                    SidebarLink(text: "Other", href: '/flame/other/other'),
                    SidebarLink(text: "Performance", href: '/flame/other/performance'),
                    SidebarLink(text: "Util", href: '/flame/other/util'),
                    SidebarLink(text: "Widget", href: '/flame/other/widgets'),
                  ],
                ),
                SidebarGroup(
                  title: "Rendering",
                  links: [
                    SidebarLink(text: "Rendering", href: '/flame/rendering/rendering'),
                    SidebarLink(text: "Images", href: '/flame/rendering/images'),
                    SidebarLink(text: "Decorators", href: '/flame/rendering/decorators'),
                    SidebarLink(text: "Layers", href: '/flame/rendering/layers'),
                    SidebarLink(text: "Palette", href: '/flame/rendering/palette'),
                    SidebarLink(text: "Particles", href: '/flame/rendering/particles'),
                    SidebarLink(text: "Post Procsessing", href: '/flame/rendering/post_processing'),
                    SidebarLink(text: "Text Rendering", href: '/flame/rendering/text_rendering'),
                  ],
                ),
                SidebarGroup(
                  title: 'Tutorials',
                  links: [
                    SidebarLink(text: "Index", href: '/tutorials/tutorials'),
                    SidebarLink(text: "Bare Flame Game", href: '/tutorials/bare_flame_game'),
                  ],
                ),
                SidebarGroup(
                  title: 'Other modules',
                  links: [
                    SidebarLink(text: "Index", href: '/other_modules/other_modules'),
                  ],
                ),
                SidebarGroup(
                  title: 'Bridge Packages',
                  links: [
                    SidebarLink(text: "Index", href: '/bridge_packages/bridge_packages'),
                  ],
                ),
                SidebarGroup(
                  title: 'Development',
                  links: [
                    SidebarLink(text: "Index", href: '/development/development'),
                    SidebarLink(text: "Contributing", href: '/development/contributing'),
                    SidebarLink(text: "Documentation", href: '/development/documentation'),
                    SidebarLink(text: "Style Guide", href: '/development/style_guide'),
                    SidebarLink(text: "Testing Guide", href: '/development/testing_guide'),
                  ],
                ),
              ],
            ),
          ),
        ],
        theme: ContentTheme(
          // Match basic content of flames.css
          primary: ThemeColor(primaryColor),
          background: ThemeColor(backgroundColor),
          text: ThemeColor(Color("#cccccc")),
          codeFont: FontFamily.list([FontFamily("SF Mono"), FontFamily("Menlo"), FontFamily("monospace")]),
          font: FontFamily.list([
            FontFamily("Ubuntu"),
            FontFamily("Roboto"),
            FontFamily("Helvetica Neue"),
            FontFamily("Arial"),
            FontFamily("sans-serif"),
          ]),
          typography: ContentTypography.base.apply(styles: Styles(), rules: []),
          colors: [
            ContentColors.headings.apply(primaryColor),
            ContentColors.code.apply(codeColor),
            ContentColors.preBg.apply(preBgColor),
            ContentColors.links.apply(linkColor),
            ContentColors.bold.apply(textColor),
          ],
        ),
      ),
    ),
  );
}
