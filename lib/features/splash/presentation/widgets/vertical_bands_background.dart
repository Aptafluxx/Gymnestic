import 'package:flutter/material.dart';
import 'package:gymnestic/core/theme/app_colors.dart';

class VerticalBandsBackground extends StatelessWidget {
  const VerticalBandsBackground({super.key});
  static const Color bandDarkGrey = Color(0xFF262A2F);
  static const Color bandLightGrey = Color(0xFF424040);
  static const Color bandRedTint = Color(0x2BF34E3A);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Align(
      alignment: Alignment.topCenter,
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.white, Colors.transparent],
            stops: [0.0, 0.20, 1.0],
          ).createShader(bounds);
        },
        blendMode: BlendMode.dstIn,
        child: SizedBox(
          height: screenHeight * 0.4,
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(flex: 3, child: Container(color: bandDarkGrey)),
              Expanded(
                flex: 3,
                child: Container(color: AppColors.backgroundBlack),
              ),
              Expanded(flex: 3, child: Container(color: bandLightGrey)),
              Expanded(
                flex: 3,
                child: Container(color: AppColors.backgroundBlack),
              ),
              Expanded(flex: 3, child: Container(color: bandRedTint)),
            ],
          ),
        ),
      ),
    );
  }
}
