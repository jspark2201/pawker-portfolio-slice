import 'dart:convert';

/// 이미지 메시지의 [message] 문자열을 URL 리스트로 파싱합니다.
/// - 1장: 단일 URL 문자열 → [url]
/// - 여러 장: JSON 배열 문자열 `'["url1","url2"]'` → [url1, url2]
List<String> imageUrlsFromMessage(String message) {
  final trimmed = message.trim();
  if (trimmed.isEmpty) return [];
  if (trimmed.startsWith('[')) {
    final list = jsonDecode(trimmed) as List<dynamic>;
    return list.map((e) => e as String).toList();
  }
  return [trimmed];
}
