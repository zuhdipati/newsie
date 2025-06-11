import 'package:flutter/material.dart';
import 'package:newsapp/features/news/presentation/widgets/shimmer/box_shimmer.dart';
import 'package:newsapp/features/news/presentation/widgets/shimmer/custom_shimmer.dart';

class HighlightNewsLoad extends StatelessWidget {
  const HighlightNewsLoad({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomShimmer(
        onLoad: BoxShimmer(
          radius: 20,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
    ));
  }
}
