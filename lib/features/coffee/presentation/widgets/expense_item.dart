import 'package:flutter/material.dart';

class CustomExpenseItem extends StatelessWidget {
   final IconData icon;
    final String label;
    final String value;
  const CustomExpenseItem({
    super.key ,
   required this.icon,
    required this. label,
    required this.value ,});

  @override
  Widget build(BuildContext context) {
    return   Row(
      children: [
        Icon(icon, color: Colors.white, size: 18),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11),
            ),
            Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
 