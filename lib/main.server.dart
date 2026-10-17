/// The entrypoint for the **server** environment.
///
/// The [main] method will only be executed on the server during pre-rendering.
/// To run code on the client, check the `main.client.dart` file.
library;

// Server-specific Jaspr import.

import 'dart:convert';

import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import 'package:jaspr_content/components/callout.dart';
import 'package:jaspr_content/components/code_block.dart';
import 'package:jaspr_content/components/github_button.dart';
import 'package:jaspr_content/components/header.dart';
import 'package:jaspr_content/components/image.dart';
import 'package:jaspr_content/components/sidebar.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:jaspr_content/theme.dart';

// This file is generated automatically by Jaspr, do not remove or edit.
import 'main.server.options.dart';

// An 'no syntax' highligher which we can use as we migration from directives
final emptyGrammar = jsonEncode(const <String, Object?>{
  'name': 'directive',
  'scopeName': 'text.plain',
  'patterns': <Object?>[],
});



void main() {
  // Initializes the server environment with the generated default options.
  Jaspr.initializeApp(
    options: defaultServerOptions,
  );

  // Starts the app.
  //
  // [ContentApp] spins up the content rendering pipeline from jaspr_content to render
  // your markdown files in the content/ directory to a beautiful documentation site.
  runApp(
    ContentApp(
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
      ],
      components: [
        // The <Info> block and other callouts.
        Callout(),
        // Adds syntax highlighting to code blocks.
        CodeBlock(
          defaultLanguage: 'dart',
          grammars: {
            // These are directives used by Sphinx
            '{include}': emptyGrammar, 
            '{toctree}': emptyGrammar,
            '{note}': emptyGrammar,
            '{warning}': emptyGrammar,
            '{error}': emptyGrammar,
            '{seealso}': emptyGrammar,
            '{deprecated}': emptyGrammar,
            '{mermaid}': emptyGrammar,
            '{flutter-app}': emptyGrammar,
            '{dartdoc}': emptyGrammar,
            
            // Languages (to be rationalised)
            'xml': emptyGrammar,
            'bash': emptyGrammar,
            'sh': emptyGrammar,
            'shell': emptyGrammar,
            'console': emptyGrammar,
            'markdown': emptyGrammar,
            'text': emptyGrammar,
            'yaml': emptyGrammar,
            'yarn': emptyGrammar,

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
              // Shows github stats.
              GitHubButton(repo: 'flame-engine/flame'),
            ],
          ),
          footer: footer([
            small([
              Component.text("The content on this page is licensed under the"),
              a(href: "https://creativecommons.org/licenses/by/4.0/", styles: Styles(color: linkColor), [Component.text("CC BY 4.0 License")]),
              Component.text("  and code samples under the"),
              a(href: "https://raw.githubusercontent.com/flame-engine/flame/main/LICENSE", styles: Styles(color: linkColor), [
                Component.text("MIT License."),
              ]),
            ]),
          ]),
          sidebar: Sidebar(
            groups: [
              // Adds navigation links to the sidebar.
              SidebarGroup(
                links: [
                  SidebarLink(text: "Flame", href: '/README.md'),
                ],
              ),
              SidebarGroup(
                title: 'Content',
                links: [
                  SidebarLink(text: "About", href: '/'),
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
  );
}

final primaryColor = Color("#ff9500");
final backgroundColor = Color("#383838");
final textColor = Color("#cccccc");
final preBgColor = Color("#202020");
final codeColor = Color("#8b9fb1");
final linkColor = Color("#ff9500");
