import 'package:flutter/material.dart';

class SelectedContainer extends StatelessWidget {
  final Color color;
  final String title;
  const SelectedContainer({
    super.key,
    required this.color,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(backgroundColor: color, radius: 10),
        SizedBox(width: 20),
        Text(title),
      ],
    );
  }
}
