import 'package:coffee_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool isLoading;

  const SocialButton({required this.icon, required this.onPressed,  this.isLoading=false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      width: 44,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child:isLoading
          ? Padding(
              padding: const EdgeInsets.all(10.0),
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.kPrimaryColor,
                ),
              ),
            )
          : IconButton(
              icon: Icon(icon, size: 24, color: Colors.white),
              onPressed: onPressed,
            ),
    );
  }
}
