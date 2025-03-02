import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:piximize/utils/colors.dart';

class FeatureCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;

  const FeatureCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  State<FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<FeatureCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(24),
        width: 300,
        decoration: BoxDecoration(
          color: isHovered ? Colors.white : Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isHovered ? primaryColor.withOpacity(0.3) : Colors.grey[200]!,
          ),
          boxShadow: [
            BoxShadow(
              color: isHovered
                  ? primaryColor.withOpacity(0.1)
                  : Colors.black.withOpacity(0.05),
              blurRadius: isHovered ? 20 : 10,
              spreadRadius: isHovered ? 5 : 0,
              offset: isHovered ? Offset(0, 10) : Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated Icon Container
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isHovered ? lightPrimaryColor : Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                widget.icon,
                size: 32,
                color: isHovered ? primaryColor : Colors.grey[700],
              ),
            ),
            SizedBox(height: 20),

            // Title with animated color
            AnimatedDefaultTextStyle(
              duration: Duration(milliseconds: 200),
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isHovered ? primaryColor : Colors.grey[800],
              ),
              child: Text(widget.title),
            ),
            SizedBox(height: 12),

            // Description
            Text(
              widget.description,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),

            // Animated Learn More Button
            SizedBox(height: 20),
            AnimatedOpacity(
              duration: Duration(milliseconds: 200),
              opacity: isHovered ? 1.0 : 0.0,
              child: TextButton(
                onPressed: () {
                  // Add functionality to show more details about the feature
                  showFeatureDetails(context);
                },
                style: TextButton.styleFrom(
                  foregroundColor: primaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Learn More',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward, size: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showFeatureDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: EdgeInsets.all(24),
          constraints: BoxConstraints(maxWidth: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    widget.icon,
                    size: 28,
                    color: primaryColor,
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                    color: Colors.grey[600],
                  ),
                ],
              ),
              SizedBox(height: 16),
              Divider(),
              SizedBox(height: 16),
              _buildFeatureDetail(),
              SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    foregroundColor: primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    'Got it',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureDetail() {
    // Customize the detail content based on the feature
    Map<String, List<String>> featureDetails = {
      'Lightning Fast': [
        '• Advanced compression algorithms for quick processing',
        '• Batch processing capabilities',
        '• Optimized for modern browsers',
        '• Instant preview of compression results',
      ],
      '100% Secure': [
        '• All processing happens locally in your browser',
        '• No data is ever uploaded to external servers',
        '• Your images remain private and secure',
        '• No registration or account required',
      ],
      'Quality Control': [
        '• Adjustable compression settings',
        '• Real-time quality preview',
        '• Smart compression algorithms',
        '• Support for various image formats',
      ],
    };

    List<String> details = featureDetails[widget.title] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.description,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.grey[700],
            height: 1.5,
          ),
        ),
        SizedBox(height: 16),
        ...details.map((detail) => Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                detail,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
            )),
      ],
    );
  }
}
