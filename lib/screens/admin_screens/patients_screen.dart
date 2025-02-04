import 'package:flutter/material.dart';
import 'package:vaidraj/widgets/custom_container.dart';

class AdminPatientsScreen extends StatelessWidget {
  const AdminPatientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomContainer(),
      ],
    );
  }
}
