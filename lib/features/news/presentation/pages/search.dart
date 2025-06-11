import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:newsapp/core/themes/app_colors.dart';
import 'package:newsapp/core/utils/toast.dart';
import 'package:newsapp/features/news/presentation/bloc/search-news-bloc/search_news_bloc.dart';
import 'package:newsapp/features/news/presentation/widgets/load/news_by_category_load.dart';
import 'package:newsapp/features/news/presentation/widgets/news_by_category_list.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  
    scrollController.addListener(() {
      // final bloc = context.read<CategoryProductBloc>();
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        // if (!bloc.state.isLoadingProduct && bloc.state.hasNextPage) {
        //   debouncer.run(
        //     () {
        //       bloc.add(
        //           GetMoreProductByCategoryEvent(bloc.state.selectedCategory));
        //     },
        //   );
        // }
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: SearchBar(
            controller: searchController,
            textStyle: WidgetStatePropertyAll(TextStyle(color: Colors.black)),
            backgroundColor: WidgetStatePropertyAll(AppColors.primary),
            shadowColor: WidgetStatePropertyAll(Colors.transparent),
            trailing: [
              IconButton(
                onPressed: () {
                  if (searchController.text.length < 3) {
                    ToastUtils.success("Please Input at least 3 characters");
                  } else {
                    context.read<SearchNewsBloc>().add(SearchNewsEvent(
                          query: searchController.text,
                          page: '1',
                          pageSize: '20',
                        ));
                  }
                  setState(() {});
                },
                icon: SvgPicture.asset(
                  'assets/svg/search.svg',
                  width: 23,
                ),
              )
            ],
          ),
        ),
        body: ListView(
          children: [
            SizedBox(height: 10),
            searchController.text.isEmpty
                ? SizedBox()
                : Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Text(
                      "Search Result For: ${searchController.text}",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
            BlocBuilder<SearchNewsBloc, SearchNewsState>(
              builder: (context, state) {
                if (state is SearchNewsLoading) {
                  return NewsByCategoryLoad();
                }
                if (state is SearchNewsError) {
                  return Center(
                    child: Text(state.errorMsg),
                  );
                }
                if (state is SearchNewsLoaded) {
                  return NewsListWidget(
                    dataNews: state.searchNews,
                  );
                }
                return SizedBox(
                    height: MediaQuery.of(context).size.height / 1.2,
                    child: Center(
                      child: Text("Data Not Found"),
                    ));
              },
            )
          ],
        ));
  }
}
