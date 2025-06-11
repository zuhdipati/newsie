import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:newsapp/core/themes/app_colors.dart';
import 'package:newsapp/features/news/domain/entities/news_category.dart';
import 'package:timeago/timeago.dart' as timeago;

class NewsListWidget extends StatelessWidget {
  const NewsListWidget({
    super.key,
    required this.dataNews,
    this.currentCategory,
  });

  final List<NewsEntity> dataNews;
  final String? currentCategory;

  @override
  Widget build(BuildContext context) {
    String changeTimeAgo(String publishedAt) {
      final dateTime = DateTime.parse(publishedAt);

      final now = DateTime.now().toUtc();
      final difference = now.difference(dateTime);

      return timeago.format(now.subtract(difference), locale: 'en');
    }

    return Column(
      children: List.generate(
          dataNews.length,
          (index) => InkWell(
                onTap: () {
                  context.pushNamed(
                    'detail',
                    queryParameters: {
                      'url': dataNews[index].url,
                      'title': dataNews[index].title,
                    },
                  );
                },
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    child: Row(
                      children: [
                        Container(
                          height: 130,
                          width: 130,
                          decoration: BoxDecoration(
                              color: AppColors.lightGrey,
                              borderRadius: BorderRadius.circular(15)),
                          child: CachedNetworkImage(
                            imageUrl: dataNews[index].urlToImage,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator.adaptive(),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
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
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              currentCategory == null
                                  ? SizedBox()
                                  : Text(
                                      currentCategory ?? '',
                                      style: TextStyle(
                                          color: Colors.red.shade600,
                                          fontWeight: FontWeight.w600),
                                    ),
                              SizedBox(height: 5),
                              Text(
                                dataNews[index].title,
                                style: TextStyle(fontSize: 17),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 5),
                              Text(
                                  "${changeTimeAgo(dataNews[index].publishedAt)} - ${dataNews[index].author}",
                                  style: TextStyle(
                                      color: AppColors.lightGrey, fontSize: 13))
                            ],
                          ),
                        )
                      ],
                    )),
              )),
    );
  }
}
