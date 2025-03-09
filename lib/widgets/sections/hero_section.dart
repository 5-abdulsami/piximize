import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:piximize/utils/colors.dart';
import 'package:piximize/widgets/piximize.dart';
import 'package:piximize/widgets/feature_card.dart';
import 'package:piximize/utils/constants.dart';

class HeroSection extends StatelessWidget {
  final bool isMobile;

  const HeroSection({
    Key? key,
    required this.isMobile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor.withOpacity(0.1),
            primaryColor.withOpacity(0.05),
          ],
        ),
      ),
      padding: EdgeInsets.symmetric(
        vertical: size.height * 0.08,
        horizontal: size.width * 0.05,
      ),
      child: Column(
        children: [
          piximize(fontSize: isMobile ? 32 : size.width * 0.05),
          SizedBox(height: size.height * 0.02),
          Text(
            "Compress images without sacrificing quality",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: isMobile ? 16 : size.width * 0.015,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: size.height * 0.01),
          Text(
            "Reduce file size by up to 90% while maintaining visual clarity",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: isMobile ? 14 : size.width * 0.012,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: size.height * 0.04),

          // Feature cards
          if (!isMobile) _buildFeatureCards(size),
        ],
      ),
    );
  }

  Widget _buildFeatureCards(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          FeatureCard(
            icon: Icons.speed_outlined,
            title: "Lightning Fast",
            description: "Compress images in seconds",
          ),
          FeatureCard(
            icon: Icons.lock_outline,
            title: "100% Secure",
            description: "Your images never leave your device",
          ),
          FeatureCard(
            icon: Icons.high_quality_outlined,
            title: "Quality Control",
            description: "Adjust compression to your needs",
          ),
        ],
      ),
    );
  }
}
