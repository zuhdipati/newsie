import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:newsapp/core/themes/app_colors.dart';
import 'package:newsapp/features/news/domain/entities/news_category.dart';
import 'package:newsapp/features/news/presentation/bloc/news-bloc/news_bloc.dart';
import 'package:newsapp/features/news/presentation/widgets/breaking_news_list.dart';
import 'package:newsapp/features/news/presentation/widgets/load/highlight_news_load.dart';
import 'package:newsapp/features/news/presentation/widgets/news_by_category_list.dart';
import 'package:newsapp/features/news/presentation/widgets/load/news_by_category_load.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  int carouselIndex = 0;
  String currentCategory = '';

  List<String> newsCategory = [
    'For You',
    'Business',
    'Entertainment',
    'General',
    'Health',
    'Science',
    'Sports',
    'Technology'
  ];

  @override
  void initState() {
    super.initState();
    context.read<NewsBloc>().add(GetForYouEvent(category: 'for you'));
    _tabController = TabController(length: newsCategory.length, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        // context.read<HomeBloc>().add(TabChanged(index: _tabController.index));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: newsCategory.length,
      child: Scaffold(
        appBar: _appBar(context),
        body: Column(
          children: [
            SizedBox(height: 10),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: NeverScrollableScrollPhysics(),
                children: List.generate(newsCategory.length, (index) {
                  return index == 0
                      ? _forYouCategory(context)
                      : _newsByCategory(newsCategory[index]);
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
        actionsPadding: EdgeInsets.all(8),
        leadingWidth: 90,
        leading: Center(
          child: Text(
            "Newsie",
            style: TextStyle(fontSize: 20),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                context.pushNamed('search');
              },
              icon: SvgPicture.asset('assets/svg/search.svg'))
        ],
        bottom: TabBar(
            controller: _tabController,
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            labelColor: AppColors.secondary,
            unselectedLabelColor: AppColors.grey,
            dividerColor: Colors.transparent,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black,
            ),
            padding: EdgeInsets.symmetric(horizontal: 8),
            labelPadding: EdgeInsets.symmetric(horizontal: 4),
            onTap: (value) {
              currentCategory = newsCategory[value];
              context
                  .read<NewsBloc>()
                  .add(ChangeTabEvent(category: currentCategory));
              setState(() {});
            },
            tabs: List.generate(newsCategory.length, (index) {
              return Tab(
                  icon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  newsCategory[index],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ));
            })));
  }

  RefreshIndicator _forYouCategory(BuildContext context) {
    return RefreshIndicator.adaptive(
      color: AppColors.grey,
      onRefresh: () async => context.read<NewsBloc>().add(RefreshEvent(category: 'for you')),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _highlightNews(context),
            SizedBox(height: 20),
            _breakingNews(),
          ],
        ),
      ),
    );
  }

  Padding _highlightNews(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: min(MediaQuery.of(context).size.width, 500),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: BlocBuilder<NewsBloc, NewsState>(
          builder: (context, state) {
            if (state is NewsTabLoading) {
              return HighlightNewsLoad();
            }
            if (state is NewsTabError) {
              return Center(
                child: Text(state.errorMsg),
              );
            }
            if (state is NewsTabLoaded) {
              List<NewsEntity> dataCategory = state.forYouNews;
              return Stack(
                children: [
                  CarouselSlider.builder(
                    itemCount: 3,
                    options: CarouselOptions(
                      viewportFraction: 1,
                      height: MediaQuery.of(context).size.width,
                      onPageChanged: (index, reason) {
                        carouselIndex = index;
                        setState(() {});
                      },
                    ),
                    itemBuilder: (context, index, realIndex) {
                      return InkWell(
                        onTap: () {
                          context.pushNamed(
                            'detail',
                            queryParameters: {
                              'url': dataCategory[index].url,
                              'title': dataCategory[index].title,
                            },
                          );
                        },
                        child: Stack(
                          children: [
                            CachedNetworkImage(
                              imageUrl: dataCategory[index].urlToImage,
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator.adaptive(),
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                        alignment: Alignment.center,
                                        fit: BoxFit.cover,
                                        image: imageProvider)),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    dataCategory[index].title,
                                    style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 27,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 15),
                                  Row(
                                    children: [
                                      Text(
                                        dataCategory[index].author,
                                        style:
                                            TextStyle(color: AppColors.primary),
                                      ),
                                      Text(" - "),
                                      Text(
                                        dataCategory[index].publishedAt,
                                        style:
                                            TextStyle(color: AppColors.primary),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 30),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        3,
                        (index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Container(
                            height: 5,
                            width: 30,
                            color: carouselIndex == index
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
            return SizedBox();
          },
        ),
      ),
    );
  }

  Column _breakingNews() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Breaking News",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              Text("See All", style: TextStyle(fontWeight: FontWeight.w600))
            ],
          ),
        ),
        SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: List.generate(
                5,
                (index) {
                  return BreakingNewsListWidget(
                    index: index,
                  );
                },
              ),
            ),
          ),
        ),
        SizedBox(height: 30),
      ],
    );
  }

  RefreshIndicator _newsByCategory(String category) {
    return RefreshIndicator.adaptive(
      color: AppColors.grey,
      onRefresh: () async {
        context.read<NewsBloc>().add(RefreshEvent(category: category));
      },
      child: SingleChildScrollView(
        child: BlocBuilder<NewsBloc, NewsState>(
          builder: (context, state) {
            if (state is NewsTabLoading) {
              return NewsByCategoryLoad();
            }
            if (state is NewsTabError) {
              return Center(
                  child: Column(
                children: [
                  Text(state.errorMsg),
                  InkWell(
                      onTap: () {
                        context.read<NewsBloc>().add(RefreshEvent(category: category));
                      },
                      child: Text(
                        "Refresh",
                        style: TextStyle(color: Colors.blue),
                      ))
                ],
              ));
            }
            if (state is NewsTabLoaded) {
              List<NewsEntity> dataNews = state.categoryNews[category] ?? [];
              return NewsListWidget(
                currentCategory: category,
                dataNews: dataNews,
              );
            }
            return SizedBox();
          },
        ),
      ),
    );
  }
}
