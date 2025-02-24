import 'package:flutter/material.dart';
import 'package:piximize/utils/colors.dart';

class QualitySlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const QualitySlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Compression Quality: ${value.toInt()}%',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Slider(
          thumbColor: primaryColor,
          activeColor: primaryColor,
          inactiveColor: primaryColor.withValues(alpha: 0.3),
          value: value,
          min: 0,
          max: 100,
          divisions: 100,
          label: value.toInt().toString(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
