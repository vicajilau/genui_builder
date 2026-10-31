## 1.0.1

- Support `analyzer` 14, `build` 5 and `source_gen` 4.3.
- Add generator and registry builder tests.

## 1.0.0

- Initial public release of the GenUI code generator package.
- Includes the annotation-driven `GenerativeUIGenerator` that emits per-widget `.genui.g.dart` files.
- Includes the registry builder that scans annotated source files and writes `lib/genui_registry.g.dart`.
- Generates catalog items, schema helpers, and the global catalog used by the example app.
- Converts widget constructor fields into JSON schema definitions and generated widget factories.
