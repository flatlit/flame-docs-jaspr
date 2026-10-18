# flame_docs_jsapr

Flame documentation built with Jaspr

## Running the project

Run your project using `jaspr serve`.

The development server will be available on `http://localhost:8080`.

## Building the project

Build your project using `jaspr build`.

The output will be located inside the `build/jaspr/` directory.

## Porting

### Work done


Based this from a jaspr documentation site (using `jaspr_content`) project, created with the VS Code plugin. 

Copied the existing `/docs` over to `/content`. 
This produced a reasonable looking site already. 
I'd added all the various markdown codeblock languages / directives to the jaspr `CodeBlock` component. 


Over the course of the port the markdown content has been unchanged.
There was one fix I think where something pointed to the wrong path. 

Did a basic port of `flame.css` into jaspr themes and styles in `main.server.dart` as well as adding some of logo and headings.

Manually added pages which are about 'flame' to the sidebar.

Swapped fontawesome for lucide as there's a dart packages for it, which jaspr recommended.

Support `{note}, {warning}, ...`  admonition and deprecated  using custom componetns which sit in front of the default codeblock pasrer. 

Supported mermaid using a custom component and then just linking pulling it from the CDN. _An alterantive would be to render to SVG using the dart port `mermaid_core`_.

To use Flutter embedding I copied all the example and tutorial code into the jaspr code. Then I've reused the routes idea, together with a `FlameExample` component, then hooked up to the existing `{flutter-app}` based directive approach. 

Setup a github pages...  is always fun.

### Problems

The server css is lost for when the client hydates (which only happens on pages with Flutter embedded).
Unclear why or how to fix.

Flame examples which use assets aren't loaded (e.g `ember.png`, `pixelation.frag`). 
Not looked into this, but imagine it's a easy fix (even if just copying to the right path).

Numerous `jaspr clean` and `jaspr serve` cycles has been required to get the flutter stuff working. Something eventually unblocked it, unclear what, or if others would have the same issue.

When Flutter embeds it often bricks my brower's web inspector pain. _this is why the asset paths haven't been fixed_. 

### Suggestions

- Drop `{:include:}` and the content can be inlined in the Markdown. This is more complex that it seems because reading a file behidn the scenes, (outside jaspr) means you need your own content pipeline for that (markdown parsing etc).  
- The `{:dartdoc:}` directive should just be a link to the API site.  
- The directives from sphix version have been used here, but that's just fighting jaspr's component.
- The jaspr sidebar (grouped link) isn't sufficient for the depth of the Flame documentation. However, the flame documentation could be spilt into sub-sections (guide, tutorials, packages, api, etc). It's also code driven (rather than declared). 
- Examples and tutorial now are within the jaspr codebase. That might be correct for examples, but feels like the tutorial app could be on their own page.
- Is the version / multi tag necessary. I can imagine that is hard to maintain and complex.  
- {flutter-app} widget, info, etc would need real thought and effort.

### Remaining

- include and dartdoc not supported
- Only flutter-app examples are embedded (i.e not tutorial apps)
- 
- Use the GithubLoader? Extend the GitHubLoader to support the versions (aka tags)? 
- Any Markdown in codeblocks needs to be preparsed (but could instead me considered to components)
- Add document head/meta
- Add fonts, improve CSS, etc
- Add syntax highlighting for the required grammars
- Add https://pub.dev/packages/jaspr_search




