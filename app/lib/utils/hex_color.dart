import 'dart:ui';

/// Parses a hex color such as `#6366F1`, `FF6366F1` or `0xFF6366F1`.
///
/// Returns `null` when [hex] is absent or not a valid 6 or 8 digit color.
Color? parseHexColor(String? hex) {
  if (hex == null) return null;
  var digits = hex.replaceAll('#', '').trim();
  if (digits.startsWith('0x')) digits = digits.substring(2);
  if (digits.length == 6) digits = 'FF$digits';
  if (digits.length != 8) return null;
  final value = int.tryParse(digits, radix: 16);
  return value == null ? null : Color(value);
}
