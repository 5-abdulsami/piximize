import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Quality indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quality: ${value.toInt()}%',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                Text(
                  _getQualityDescription(value),
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: _getQualityColor(value),
                  ),
                ),
              ],
            ),
            Tooltip(
              message: 'Higher quality means larger file size',
              child: Icon(
                Icons.info_outline,
                size: 20,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
        SizedBox(height: 16),

        // Custom slider with markers
        Stack(
          children: [
            // Quality level markers
            Positioned.fill(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildQualityMarker('Low', 20),
                  _buildQualityMarker('Medium', 50),
                  _buildQualityMarker('High', 80),
                ],
              ),
            ),

            // Main slider
            SliderTheme(
              data: SliderThemeData(
                trackHeight: 6,
                activeTrackColor: _getSliderColor(value),
                inactiveTrackColor: Colors.grey[200],
                thumbColor: Colors.white,
                overlayColor: primaryColor.withOpacity(0.1),
                thumbShape: _CustomThumbShape(),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 24),
                tickMarkShape: RoundSliderTickMarkShape(tickMarkRadius: 0),
                activeTickMarkColor: Colors.transparent,
                inactiveTickMarkColor: Colors.transparent,
              ),
              child: Slider(
                value: value,
                min: 0,
                max: 100,
                divisions: 100,
                onChanged: (newValue) {
                  onChanged(newValue);
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 24),

        // Quality level explanation
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Quality Level Guide',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 12),
              _buildQualityLevelInfo(
                '80-100%',
                'Best for professional use and printing',
                Icons.star,
                Colors.amber,
              ),
              SizedBox(height: 8),
              _buildQualityLevelInfo(
                '40-79%',
                'Good for web and social media',
                Icons.thumb_up,
                Colors.green,
              ),
              SizedBox(height: 8),
              _buildQualityLevelInfo(
                '0-39%',
                'Suitable for thumbnails and previews',
                Icons.compress,
                Colors.blue,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQualityMarker(String label, double position) {
    final bool isActive = value >= position;
    return Container(
      width: 2,
      height: 40,
      child: Column(
        children: [
          Container(
            width: 2,
            height: 12,
            color: isActive ? _getSliderColor(value) : Colors.grey[300],
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: isActive ? _getSliderColor(value) : Colors.grey[400],
              fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQualityLevelInfo(
    String range,
    String description,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 16,
            color: color,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                range,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              Text(
                description,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getQualityDescription(double value) {
    if (value >= 80) return 'Professional Quality';
    if (value >= 40) return 'Balanced Quality';
    return 'Maximum Compression';
  }

  Color _getQualityColor(double value) {
    if (value >= 80) return Colors.amber[700]!;
    if (value >= 40) return Colors.green[600]!;
    return Colors.blue[600]!;
  }

  Color _getSliderColor(double value) {
    if (value >= 80) return Colors.amber[400]!;
    if (value >= 40) return Colors.green[400]!;
    return Colors.blue[400]!;
  }
}

class _CustomThumbShape extends SliderComponentShape {
  final double enabledThumbRadius = 12;
  final double elevation = 4;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(enabledThumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    // Draw shadow
    final Path shadowPath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: enabledThumbRadius));
    canvas.drawShadow(shadowPath, Colors.black, elevation, true);

    // Draw thumb
    final Paint thumbPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final Paint borderPaint = Paint()
      ..color = sliderTheme.activeTrackColor ?? Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(center, enabledThumbRadius, thumbPaint);
    canvas.drawCircle(center, enabledThumbRadius, borderPaint);
  }
}
