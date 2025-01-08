import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SharpPointClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 0); // Start at the top-left
    path.lineTo(size.width - 10,
        0); // Line to the top-right (a bit shorter for sharp edge)
    path.lineTo(
        size.width, size.height / 2); // Make the sharp point at the middle
    path.lineTo(size.width - 10, size.height); // Bottom-right
    path.lineTo(0, size.height); // Bottom-left
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class MySharpPointContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: SharpPointClipper(), // Apply the custom clipper
      child: Container(
        // color: Colors
        // .green, // This is the color of your container with the sharp point
        height: 8.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              Icons.home,
              // color: Colors.white, // Icon color
              size: 10.w,
            ),
            SizedBox(
              width: 5.w,
            ),
            Text(
              "Home",
              style: TextStyle(
                fontSize: 16.sp,
                // color: Colors.white, // Text color
              ),
            ),
            SizedBox(
              width: 20.w,
            ),
            Container(
              // color: Colors.white, // Small container at the end
              width: 3.w,
            ),
          ],
        ),
      ),
    );
  }
}
