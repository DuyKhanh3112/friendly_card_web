import 'dart:convert';

class Tool {
  static String extractJsonArray(String input) {
    final regex = RegExp(r'```json\s*(\[.*?\])\s*```', dotAll: true);
    final match = regex.firstMatch(input);
    if (match != null) {
      return match.group(1)!;
    }
    return '[]';
  }

  static List<Map<String, dynamic>> parseList(String rawText) {
    final jsonArrayString = extractJsonArray(rawText);
    final parsed = json.decode(jsonArrayString);
    return List<Map<String, dynamic>>.from(parsed);
  }
}
