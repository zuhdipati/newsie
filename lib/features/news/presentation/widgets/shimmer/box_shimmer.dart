import 'package:flutter/material.dart';

class BoxShimmer extends StatelessWidget {
  final double width;
  final double height;
  final EdgeInsetsGeometry margin;
  final double radius;

  const BoxShimmer({
    super.key,
    this.width = double.infinity,
    this.height = 0.0,
    this.margin = const EdgeInsets.all(0.0),
    this.radius = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: const SizedBox(),
    );
  }
}
