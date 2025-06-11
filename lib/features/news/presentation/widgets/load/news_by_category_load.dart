import 'package:flutter/material.dart';
import 'package:newsapp/features/news/presentation/widgets/shimmer/box_shimmer.dart';
import 'package:newsapp/features/news/presentation/widgets/shimmer/custom_shimmer.dart';

class NewsByCategoryLoad extends StatelessWidget {
  const NewsByCategoryLoad({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: CustomShimmer(
          onLoad: SingleChildScrollView(
        child: Column(
          children: List.generate(
            5,
            (index) {
              return SizedBox(
                height: 130,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BoxShimmer(
                    radius: 15,
                  ),
                ),
              );
            },
          ),
        ),
      )),
    );
  }
}
