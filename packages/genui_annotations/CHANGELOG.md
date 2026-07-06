## 1.0.0

- Initial public release of the GenUI annotations package.
- Provides the `@GenerativeUI` and `@generativeUI` markers used by the builder to detect widgets.
- Exposes `GenUiEvent` for decoding interaction payloads emitted by generated callback wiring.
- Keeps the runtime-facing API small so application code only depends on annotations and event parsing.
