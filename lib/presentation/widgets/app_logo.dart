import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final Color? color;

  const AppLogo({
    super.key,
    this.size = 100,
    this.showText = true,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color ?? AppColors.primary, width: 2),
          ),
          child: Center(
            child: Text(
              'LS',
              style: GoogleFonts.playfairDisplay(
                color: color ?? AppColors.primary,
                fontSize: size * 0.5,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
        if (showText) ...[
          const SizedBox(height: 8),
          Text(
            'LUXORA STAY',
            style: GoogleFonts.playfairDisplay(
              color: color ?? AppColors.primary,
              fontSize: size * 0.18,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          Text(
            'HOTELS & RESORTS',
            style: GoogleFonts.lato(
              color: color ?? AppColors.primary,
              fontSize: size * 0.08,
              fontWeight: FontWeight.w400,
              letterSpacing: 4,
            ),
          ),
        ],
      ],
    );
  }
}
