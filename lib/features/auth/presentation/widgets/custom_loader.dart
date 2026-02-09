import 'package:coffee_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomLoader extends StatelessWidget {
  

  const CustomLoader({Key? key, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Transparent background overlay
        Opacity(
          opacity: 0.2,
          child: ModalBarrier(
            dismissible: false,
            color: AppColors.background.withValues(alpha: 0.5),
          ),
        ),
        // Centered loader
        Center(
          child: Container(
            height: 180,
            width: 180,
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.background.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: SpinKitSpinningLines(
              color: AppColors.kPrimaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
