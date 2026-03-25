import 'dart:async';

import 'package:app_links/app_links.dart';

/// 딥링크 URL 생성/해석
///
/// 앱이 설치된 상태에서 링크 클릭 시 해당 화면으로 이동합니다.
/// (디퍼드 딥링크: 앱 미설치 → 설치 후 연결은 별도 스펙/서비스 필요)
///
/// - 커스텀 스킴: `pawker://` (서버 설정 없이 동작)
/// - 추후 Universal Links / App Links 시 `baseUrl`만 웹 도메인으로 변경 가능
class DeepLink {
  DeepLink._();

  static final AppLinks _appLinks = AppLinks();

  /// 공유/딥링크용 base URL. ventail.it.kr + Universal/App Links 사용 (카카오톡 등에서 링크로 인식)
  static const String baseUrl = 'https://ventail.it.kr';

  /// 구인 글 상세 딥링크 경로 (path만, baseUrl 제외)
  static const String ownerJobDetailPath = '/owner/job/detail';

  /// 구직 글 상세 딥링크 경로 (path만)
  static const String walkerJobDetailPath = '/walker/job/detail';

  /// 구인 글 상세 공유 URL
  static String ownerJobDetail(String jobId) {
    return '$baseUrl$ownerJobDetailPath/$jobId';
  }

  /// 구직 글 상세 공유 URL
  static String walkerJobDetail(String walkerId) {
    return '$baseUrl$walkerJobDetailPath/$walkerId';
  }

  /// 앱이 링크로 켜졌을 때 초기 링크 반환. 없으면 null.
  static Future<Uri?> getInitialLink() => _appLinks.getInitialLink();

  /// 앱이 이미 실행 중일 때 링크로 들어온 이벤트 스트림
  static Stream<Uri> get uriLinkStream => _appLinks.uriLinkStream;

  /// URI가 구인/구직 글 상세 경로면 라우터에 쓸 path 반환, 아니면 null
  ///
  /// - https: path가 이미 /owner/job/detail/xxx 또는 /walker/job/detail/xxx
  /// - pawker / pawkerdev: 웹에서 pawker://owner/job/detail/123 또는 pawkerdev://walker/job/detail/123 형태 → host + path 로 복원
  static String? pathForJobDetail(Uri? uri) {
    if (uri == null) return null;
    String path = uri.path;
    if ((uri.scheme == 'pawker' || uri.scheme == 'pawkerdev') && uri.host.isNotEmpty) {
      path = '/${uri.host}${path.startsWith('/') ? path : '/$path'}';
    }
    if (path.startsWith(ownerJobDetailPath) && path.length > ownerJobDetailPath.length) return path;
    if (path.startsWith(walkerJobDetailPath) && path.length > walkerJobDetailPath.length) return path;
    return null;
  }
}
