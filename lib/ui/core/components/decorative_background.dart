import 'package:flutter/material.dart';
import 'package:pawker/ui/core/themes/theme.dart';

/// 곡선 형태의 장식 배경을 그리는 CustomPainter
/// 화면 상단, 하단에 여러 색상의 유기적인 곡선을 배치합니다.
class DecorativeBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 상단 오른쪽 - 주황/핑크 곡선
    _drawTopRightCurve(canvas, size);

    // 하단 왼쪽 - 빨강 곡선
    _drawBottomLeftCurve(canvas, size);

    // 하단 오른쪽 - 민트/시안 곡선
    _drawBottomRightCurve(canvas, size);

    // 하단 중앙 - 노랑 곡선
    _drawBottomCenterCurve(canvas, size);
  }

  /// 상단 오른쪽 곡선 (주황/핑크)
  void _drawTopRightCurve(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              AppColors.accent.withOpacity(0.3),
              AppColors.accentLight.withOpacity(0.2),
            ],
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height * 0.4))
          ..style = PaintingStyle.fill;

    final path =
        Path()
          ..moveTo(size.width, 0)
          ..lineTo(size.width, size.height * 0.15)
          ..cubicTo(
            size.width * 0.85,
            size.height * 0.2,
            size.width * 0.7,
            size.height * 0.15,
            size.width * 0.5,
            size.height * 0.18,
          )
          ..cubicTo(
            size.width * 0.3,
            size.height * 0.21,
            size.width * 0.1,
            size.height * 0.3, // x축을 좀 더 0에 가깝게 조절
            -size.width * 0.1,
            size.height * 0.45, // 아예 화면 왼쪽 밖(-x)까지 곡선을 연장
          )
          ..lineTo(-size.width * 0.1, 0) // 화면 밖에서 상단으로 이동
          ..close();

    canvas.drawPath(path, paint);
  }

  /// 하단 왼쪽 곡선 (빨강/핑크)
  void _drawBottomLeftCurve(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [
              AppColors.error.withOpacity(0.4),
              AppColors.accent.withOpacity(0.3),
            ],
          ).createShader(
            Rect.fromLTWH(
              0,
              size.height * 0.6,
              size.width * 0.5,
              size.height * 0.4,
            ),
          )
          ..style = PaintingStyle.fill;

    final path =
        Path()
          ..moveTo(0, size.height)
          ..lineTo(0, size.height * 0.75)
          ..cubicTo(
            size.width * 0.05,
            size.height * 0.72,
            size.width * 0.1,
            size.height * 0.78,
            size.width * 0.2,
            size.height * 0.8,
          )
          ..cubicTo(
            size.width * 0.35,
            size.height * 0.83, // 제어점 확장
            size.width * 0.45,
            size.height * 0.95, // 제어점 확장
            size.width * 0.5,
            size.height * 1.1, // 화면 바닥 아래(1.1)로 넘김
          )
          ..lineTo(0, size.height * 1.1) // 아래쪽에서 닫음
          ..close();

    canvas.drawPath(path, paint);
  }

  /// 하단 오른쪽 곡선 (민트/시안)
  void _drawBottomRightCurve(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            colors: [
              AppColors.supportBlue.withOpacity(0.4),
              AppColors.supportBlue.withOpacity(0.2),
            ],
          ).createShader(
            Rect.fromLTWH(
              size.width * 0.5,
              size.height * 0.6,
              size.width * 0.5,
              size.height * 0.4,
            ),
          )
          ..style = PaintingStyle.fill;

    final path =
        Path()
          ..moveTo(size.width, size.height)
          ..lineTo(size.width, size.height * 0.7)
          ..cubicTo(
            size.width * 0.9,
            size.height * 0.75,
            size.width * 0.8,
            size.height * 0.72,
            size.width * 0.7,
            size.height * 0.78,
          )
          ..cubicTo(
            size.width * 0.55,
            size.height * 0.85,
            size.width * 0.45,
            size.height * 0.95,
            size.width * 0.4,
            size.height * 1.1, // 화면 바닥 아래로 연장
          )
          ..lineTo(size.width, size.height * 1.1)
          ..close();

    canvas.drawPath(path, paint);
  }

  /// 하단 중앙 곡선 (노랑)
  void _drawBottomCenterCurve(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              AppColors.warning.withOpacity(0.5),
              AppColors.warningLight.withOpacity(0.2),
            ],
          ).createShader(
            Rect.fromLTWH(
              size.width * 0.2,
              size.height * 0.8,
              size.width * 0.6,
              size.height * 0.2,
            ),
          )
          ..style = PaintingStyle.fill;

    final path =
        Path()
          ..moveTo(size.width * 0.2, size.height * 1.1) // 바닥 아래 시작
          ..cubicTo(
            size.width * 0.25,
            size.height * 0.95,
            size.width * 0.3,
            size.height * 0.92,
            size.width * 0.35,
            size.height * 0.92, // 부드러운 시작점
          )
          ..cubicTo(
            size.width * 0.45,
            size.height * 0.88,
            size.width * 0.55,
            size.height * 0.88,
            size.width * 0.65,
            size.height * 0.94,
          )
          ..cubicTo(
            size.width * 0.75,
            size.height * 0.98,
            size.width * 0.8,
            size.height * 1.05,
            size.width * 0.85,
            size.height * 1.1, // 부드러운 끝점
          )
          ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 곡선 배경을 표시하는 위젯
class DecorativeBackground extends StatelessWidget {
  final Widget? child;

  const DecorativeBackground({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 배경색
        Container(color: AppColors.background),

        // 곡선 장식
        Positioned.fill(
          child: CustomPaint(painter: DecorativeBackgroundPainter()),
        ),

        // 자식 위젯
        if (child != null) child!,
      ],
    );
  }
}
