import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:newsapp/core/themes/app_colors.dart';
import 'package:newsapp/features/news/domain/entities/news_category.dart';
import 'package:newsapp/features/news/presentation/bloc/news-bloc/news_bloc.dart';
import 'package:newsapp/features/news/presentation/widgets/load/breaking_news_load.dart';
import 'package:timeago/timeago.dart' as timeago;

class BreakingNewsListWidget extends StatelessWidget {
  const BreakingNewsListWidget({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    String changeTimeAgo(String publishedAt) {
      final dateTime = DateTime.parse(publishedAt);

      final now = DateTime.now().toUtc();
      final difference = now.difference(dateTime);

      return timeago.format(now.subtract(difference), locale: 'en');
    }

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: SizedBox(
        width: 220,
        child: BlocBuilder<NewsBloc, NewsState>(
          builder: (context, state) {
            if (state is NewsTabLoading) {
              return BreakingNewsLoad();
            }
            if (state is NewsTabError) {
              return Center(
                child: Text(state.errorMsg),
              );
            }

            if (state is NewsTabLoaded) {
              List<NewsEntity> dataNews = state.forYouNews;
              return InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  context.pushNamed(
                    'detail',
                    queryParameters: {
                      'url': dataNews[index].url,
                      'title': dataNews[index].title,
                    },
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 150,
                      width: 220,
                      decoration: BoxDecoration(
                          color: AppColors.grey,
                          borderRadius: BorderRadius.circular(15)),
                      child: CachedNetworkImage(
                        imageUrl: dataNews[index].urlToImage,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                  alignment: Alignment.center,
                                  fit: BoxFit.cover,
                                  image: imageProvider)),
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text(
                        dataNews[index].title,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                    SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text(
                          "${changeTimeAgo(dataNews[index].publishedAt)} - ${dataNews[index].author}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.lightGrey,
                            fontSize: 13,
                          )),
                    )
                  ],
                ),
              );
            }
            return SizedBox();
          },
        ),
      ),
    );
  }
}
