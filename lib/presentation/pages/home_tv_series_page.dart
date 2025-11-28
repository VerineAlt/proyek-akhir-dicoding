import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_list/tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_list/tv_series_list.dart';
import 'package:ditonton/presentation/bloc/tv_list/tv_series_state.dart'; 
import 'package:ditonton/presentation/pages/about_page.dart';

import 'package:ditonton/presentation/pages/popular_tv_series_page.dart';

import 'package:ditonton/presentation/pages/search_tv_series_page.dart';

import 'package:ditonton/presentation/pages/top_rated_tv_series_page.dart';
import 'package:ditonton/presentation/pages/tv_series_detail_page.dart';
import 'package:ditonton/presentation/pages/watchlist_tv_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TvSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv';

  @override
  _TvSeriesPageState createState() => _TvSeriesPageState();
}

class _TvSeriesPageState extends State<TvSeriesPage> {
  @override
  void initState() {
    super.initState();
    // Fetch all 3 lists using their respective Blocs
    Future.microtask(() {
      context.read<AiringTodayTvSeriesBloc>().add(FetchAiringTodayTvSeries()); 
      context.read<PopularTvSeriesBloc>().add(FetchPopularTvSeries());
      context.read<TopRatedTvSeriesBloc>().add(FetchTopRatedTvSeries());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
                backgroundColor: Colors.grey.shade900,
              ),
              accountName: Text('Ditonton'),
              accountEmail: Text('ditonton@dicoding.com'),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
              ),
            ),
            
            ListTile(
              leading: Icon(Icons.save_alt),
              title: Text('Watchlist'),
              onTap: () {
                Navigator.pushNamed(context, WatchlistTvPage.ROUTE_NAME);
              },
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, AboutPage.ROUTE_NAME);
              },
              leading: Icon(Icons.info_outline),
              title: Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Ditonton TV Series'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchTvPage.ROUTE_NAME);
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
              // 1. Airing Today
              Text('Airing Today', style: kHeading6),
              BlocBuilder<AiringTodayTvSeriesBloc, TvSeriesState>(
                  builder: (context, state) {
                if (state is TvSeriesLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is TvSeriesHasData) {
                  return TvSeriesList(state.result);
                } else if (state is TvSeriesError) {
                  return Text(state.message);
                } else {
                  return Container();
                }
              }),

              // 2. Popular
              _buildSubHeading(
                title: 'Popular',
                onTap: () {
                  Navigator.pushNamed(context, PopularTvPage.ROUTE_NAME);
                },
              ),
              BlocBuilder<PopularTvSeriesBloc, TvSeriesState>(
                  builder: (context, state) {
                if (state is TvSeriesLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is TvSeriesHasData) {
                  return TvSeriesList(state.result);
                } else if (state is TvSeriesError) {
                  return Text(state.message);
                } else {
                  return Container();
                }
              }),

              // 3. Top Rated
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () {
                  Navigator.pushNamed(context, TopRatedTvPage.ROUTE_NAME);
                },
              ),
              BlocBuilder<TopRatedTvSeriesBloc, TvSeriesState>(
                  builder: (context, state) {
                if (state is TvSeriesLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is TvSeriesHasData) {
                  return TvSeriesList(state.result);
                } else if (state is TvSeriesError) {
                  return Text(state.message);
                } else {
                  return Container();
                }
              }),
            ],
          ),
        ),
      ),
    );
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
          final series = tvSeries[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TvSeriesDetailPage.ROUTE_NAME,
                  arguments: series.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${series.posterPath}',
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