/// 예외/에러를 사용자에게 보여줄 수 있는 짧은 메시지로 변환합니다.
/// SnackBar 등에서 그대로 사용할 수 있습니다.
String toUserFriendlyMessage(Object? error) {
  if (error == null) return '일시적인 오류가 발생했어요. 잠시 후 다시 시도해주세요.';
  final s = error.toString().replaceFirst(RegExp(r'^Exception:\s*'), '');
  final lower = s.toLowerCase();

  // 네트워크/연결
  if (lower.contains('socket') ||
      lower.contains('connection') ||
      lower.contains('network') ||
      lower.contains('connection refused') ||
      lower.contains('failed host lookup') ||
      lower.contains('connection reset')) {
    return '네트워크 연결을 확인해주세요.';
  }
  if (lower.contains('timeout') || lower.contains('timed out')) {
    return '요청이 지연되고 있어요. 잠시 후 다시 시도해주세요.';
  }

  // HTTP 상태
  if (s.contains('409') ||
      lower.contains('duplicate') ||
      lower.contains('already exists')) {
    return '이미 등록된 내용이에요.';
  }
  if (s.contains('401') ||
      lower.contains('unauthorized') ||
      lower.contains('token')) {
    return '다시 로그인해주세요.';
  }
  if (s.contains('403') || lower.contains('forbidden')) {
    return '권한이 없어요.';
  }
  if (s.contains('404') || lower.contains('not found')) {
    return '요청한 내용을 찾을 수 없어요.';
  }
  if (RegExp(r'5\d{2}').hasMatch(s)) {
    return '일시적인 오류예요. 잠시 후 다시 시도해주세요.';
  }
  if (RegExp(r'4\d{2}').hasMatch(s)) {
    return '요청을 처리할 수 없어요.';
  }

  // 이미 한국어로 된 짧은 문장이면 그대로 (예: "이미 오늘 출석했어요")
  if (s.length <= 40 && RegExp(r'[가-힣]').hasMatch(s)) {
    return s;
  }

  return '일시적인 오류가 발생했어요. 잠시 후 다시 시도해주세요.';
}

/// 채팅 메시지·이미지 전송 실패 시 (403 등). 리스트는 유지하고 토스트만 쓸 때 사용.
String toChatSendUserFriendlyMessage(Object? error) {
  if (error == null) {
    return '메시지를 보낼 수 없어요. 잠시 후 다시 시도해주세요.';
  }
  final s = error.toString().replaceFirst(RegExp(r'^Exception:\s*'), '');
  final lower = s.toLowerCase();

  if (s.contains('403') || lower.contains('forbidden')) {
    return '탈퇴했거나 대화할 수 없는 상대에게는 메시지를 보낼 수 없어요.';
  }

  return toUserFriendlyMessage(error);
}
