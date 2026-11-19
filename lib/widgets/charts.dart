import 'dart:math';

import 'package:flutter/material.dart';

import '../app_theme.dart';

class CalorieRing extends StatelessWidget {
  const CalorieRing({super.key, required this.value, required this.goal});

  final int value;
  final int goal;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 132,
      height: 132,
      child: CustomPaint(
        painter: _RingPainter(goal == 0 ? 0 : value / goal),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FittedBox(
                child: Text(
                  '$value',
                  style: const TextStyle(
                    fontSize: 40,
                    height: 1,
                    fontWeight: FontWeight.w900,
                    color: AppColors.ink,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'KCAL',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.progress);

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 14.0;
    final rect = Offset.zero & size;
    final arcRect = rect.deflate(stroke / 2);
    final track = Paint()
      ..color = AppColors.track
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;
    final fill = Paint()
      ..color = progress > 1 ? AppColors.blue : AppColors.ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(arcRect, 0, 2 * pi, false, track);
    canvas.drawArc(
      arcRect,
      -pi / 2,
      2 * pi * progress.clamp(0.0, 1.0),
      false,
      fill,
    );
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class MacroChip extends StatelessWidget {
  const MacroChip({
    super.key,
    required this.label,
    required this.value,
    required this.goal,
    required this.color,
  });

  final String label;
  final double value;
  final double goal;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final progress = goal == 0 ? 0.0 : (value / goal).clamp(0.0, 1.0);
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(22),
        border: Border.fromBorderSide(popBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 2),
          FittedBox(
            child: Text(
              '${value.round()}/${goal.round()}g',
              style: const TextStyle(fontFamily: monoFont, fontSize: 15),
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              color: AppColors.ink,
              backgroundColor: AppColors.ink.withValues(alpha: 0.18),
            ),
          ),
        ],
      ),
    );
  }
}

class HistoryChart extends StatelessWidget {
  const HistoryChart({super.key, required this.values, required this.endDay});

  final List<int> values;
  final DateTime endDay;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      width: double.infinity,
      child: CustomPaint(painter: _HistoryPainter(values, endDay)),
    );
  }
}

class _HistoryPainter extends CustomPainter {
  _HistoryPainter(this.values, this.endDay);

  final List<int> values;
  final DateTime endDay;

  @override
  void paint(Canvas canvas, Size size) {
    const left = 44.0;
    const bottom = 28.0;
    const top = 8.0;
    final chartHeight = size.height - bottom - top;
    final chartWidth = size.width - left;
    final maxValue = max(3000, values.fold(0, max)).toDouble();
    final grid = Paint()
      ..color = const Color(0xFFE6E6E6)
      ..strokeWidth = 1;
    final axis = Paint()
      ..color = AppColors.muted
      ..strokeWidth = 1.5;
    final textStyle = const TextStyle(fontSize: 11, color: AppColors.muted);

    for (final mark in [0, maxValue ~/ 2, maxValue.toInt()]) {
      final y = top + chartHeight * (1 - mark / maxValue);
      canvas.drawLine(Offset(left, y), Offset(size.width, y), grid);
      final tp = TextPainter(
        text: TextSpan(text: '$mark', style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(left - tp.width - 6, y - tp.height / 2));
    }
    canvas.drawLine(Offset(left, top), Offset(left, top + chartHeight), axis);
    canvas.drawLine(
      Offset(left, top + chartHeight),
      Offset(size.width, top + chartHeight),
      axis,
    );

    final slot = chartWidth / values.length;
    final bar = Paint()..color = AppColors.blue;
    for (var i = 0; i < values.length; i++) {
      final h = chartHeight * (values[i] / maxValue);
      final x = left + slot * i + slot * 0.22;
      if (h > 0) {
        canvas.drawRRect(
          RRect.fromRectAndCorners(
            Rect.fromLTWH(x, top + chartHeight - h, slot * 0.56, h),
            topLeft: const Radius.circular(4),
            topRight: const Radius.circular(4),
          ),
          bar,
        );
      }
      if ((values.length - 1 - i) % 2 == 0) {
        final day = endDay.subtract(Duration(days: values.length - 1 - i));
        final tp = TextPainter(
          text: TextSpan(text: '${day.month}/${day.day}', style: textStyle),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(
          canvas,
          Offset(x + slot * 0.28 - tp.width / 2, top + chartHeight + 8),
        );
      }
    }
  }

  @override
  bool shouldRepaint(_HistoryPainter oldDelegate) => true;
}
