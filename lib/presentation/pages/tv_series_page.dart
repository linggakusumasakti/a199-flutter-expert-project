import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/pages/airing_today_tv_series_page.dart';
import 'package:ditonton/presentation/pages/popular_tv_series_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_series_page.dart';
import 'package:ditonton/presentation/pages/tv_series_detail_page.dart';
import 'package:ditonton/presentation/provider/tv_series_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TvSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = "/tv-series-popular";

  @override
  State createState() => _TvSeriesPage();
}

class _TvSeriesPage extends State<TvSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<TvSeriesNotifier>(context, listen: false)
      ..fetchAiringTodayTvSeries()
      ..fetchTopRatedTvSeries()
      ..fetchPopularTvSeries());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('TV Series'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, SearchPage.ROUTE_NAME, arguments: 0);
              },
              icon: Icon(Icons.search),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSubHeading(
                    title: 'Popular',
                    onTap: () => {
                      Navigator.pushNamed(
                          context, PopularTvSeriesPage.ROUTE_NAME)
                    }),
                Consumer<TvSeriesNotifier>(
                  builder: (context, data, child) {
                    final state = data.popularTvSeriesState;
                    if (state == RequestState.Loading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state == RequestState.Loaded) {
                      return TvSeriesList(data.popularTvSeries);
                    } else {
                      return Text('Failed');
                    }
                  },
                ),
                _buildSubHeading(
                    title: 'Top Rated',
                    onTap: () => {
                      Navigator.pushNamed(
                          context, TopRatedTvSeriesPage.ROUTE_NAME)
                    }),
                Consumer<TvSeriesNotifier>(
                  builder: (context, data, child) {
                    final state = data.topRatedTvSeriesState;
                    if (state == RequestState.Loading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state == RequestState.Loaded) {
                      return TvSeriesList(data.topRatedTvSeries);
                    } else {
                      return Text('Failed');
                    }
                  },
                ),
                _buildSubHeading(
                    title: 'Airing Today',
                    onTap: () => {
                      Navigator.pushNamed(
                          context, AiringTodayTvSeriesPage.ROUTE_NAME)
                    }),
                Consumer<TvSeriesNotifier>(
                  builder: (context, data, child) {
                    final state = data.airingTodayTvSeriesState;
                    if (state == RequestState.Loading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state == RequestState.Loaded) {
                      return TvSeriesList(data.airingTodayTvSeries);
                    } else {
                      return Text('Failed');
                    }
                  },
                )
              ],
            ),
          )
        ));
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class TvSeriesList extends StatelessWidget {
  final List<TvSeries> tvSeries;

  TvSeriesList(this.tvSeries);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tv = tvSeries[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, TvSeriesDetailPage.ROUTE_NAME,
                    arguments: tv.id);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tv.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvSeries.length,
      ),
    );
  }
}
