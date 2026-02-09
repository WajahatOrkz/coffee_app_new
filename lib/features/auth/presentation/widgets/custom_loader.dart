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
            color: Colors.black,
          ),
        ),
        // Centered loader
        Center(
          child: Container(
            height: 180,
            width: 180,
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(16),
            ),
            child: SpinKitSpinningLines(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
