import 'package:flutter/material.dart';
import 'package:newsapp/features/news/presentation/widgets/shimmer/box_shimmer.dart';
import 'package:newsapp/features/news/presentation/widgets/shimmer/custom_shimmer.dart';

class BreakingNewsLoad extends StatelessWidget {
  const BreakingNewsLoad({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomShimmer(
        onLoad: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          5,
          (index) => BoxShimmer(
            radius: 20,
            width: 220,
            height: 150,
          ),
        ),
      ),
    ));
  }
}
