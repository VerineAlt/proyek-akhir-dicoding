import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_event.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail';

  final int id;
  MovieDetailPage({required this.id});

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MovieDetailBloc>().add(FetchMovieDetail(widget.id));
      context.read<MovieDetailBloc>().add(LoadWatchlistStatus(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MovieDetailBloc, MovieDetailState>(
        // 🛑 FIX: Prevent rebuilds for Watchlist events!
        // This tells the builder: "Only rebuild if the state is Loading, HasData, or Error."
        // If it's WatchlistActionSuccess, KEEP the old UI (don't run the builder function).
        buildWhen: (previous, current) {
          return current is MovieDetailLoading ||
              current is MovieDetailHasData ||
              current is MovieDetailError;
        },
        builder: (context, state) {
          if (state is MovieDetailLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is MovieDetailHasData) {
            final movie = state.movie;
            return SafeArea(
              child: DetailContent(
                movie,
                state.recommendations,
                state.isAddedToWatchlist,
              ),
            );
          } else if (state is MovieDetailError) {
            return Text(state.message);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class DetailContent extends StatefulWidget {
  final MovieDetail movie;
  final List<Movie> recommendations;
  final bool isAddedWatchlist;

  DetailContent(this.movie, this.recommendations, this.isAddedWatchlist);

  @override
  State<DetailContent> createState() => _DetailContentState();
}

class _DetailContentState extends State<DetailContent> {
  late bool isAddedWatchlist;

  @override
  void initState() {
    super.initState();
    isAddedWatchlist = widget.isAddedWatchlist;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Listener handles the side effects (Snackbars) without rebuilding the whole page
    return BlocListener<MovieDetailBloc, MovieDetailState>(
      listener: (context, state) {
        if (state is WatchlistActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)));
          
          // Toggle local state immediately for UI responsiveness
          setState(() {
            isAddedWatchlist = !isAddedWatchlist;
          });
        } else if (state is WatchlistActionError) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text(state.message),
                );
              });
        }
      },
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl:
                'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}',
            width: screenWidth,
            placeholder: (context, url) => Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          Container(
            margin: const EdgeInsets.only(top: 48 + 8),
            child: DraggableScrollableSheet(
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: kRichBlack,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  padding: const EdgeInsets.only(
                    left: 16,
                    top: 16,
                    right: 16,
                  ),
                  child: Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.movie.title,
                                style: kHeading5,
                              ),
                              FilledButton(
                                onPressed: () async {
                                  if (!isAddedWatchlist) {
                                    context
                                        .read<MovieDetailBloc>()
                                        .add(AddWatchlist(widget.movie));
                                  } else {
                                    context
                                        .read<MovieDetailBloc>()
                                        .add(RemoveWatchlistEvent(widget.movie));
                                  }
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    isAddedWatchlist
                                        ? Icon(Icons.check)
                                        : Icon(Icons.add),
                                    Text('Watchlist'),
                                  ],
                                ),
                              ),
                              Text(
                                _showGenres(widget.movie.genres),
                              ),
                              Text(
                                _showDuration(widget.movie.runtime),
                              ),
                              Row(
                                children: [
                                  RatingBarIndicator(
                                    rating: widget.movie.voteAverage / 2,
                                    itemCount: 5,
                                    itemBuilder: (context, index) => Icon(
                                      Icons.star,
                                      color: kMikadoYellow,
                                    ),
                                    itemSize: 24,
                                  ),
                                  Text('${widget.movie.voteAverage}')
                                ],
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Overview',
                                style: kHeading6,
                              ),
                              Text(
                                widget.movie.overview,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Recommendations',
                                style: kHeading6,
                              ),
                              _buildRecommendationsList(context, widget.recommendations),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          color: Colors.white,
                          height: 4,
                          width: 48,
                        ),
                      ),
                    ],
                  ),
                );
              },
              minChildSize: 0.25,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: kRichBlack,
              foregroundColor: Colors.white,
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  // --- Helper for Recommendations (Same as before) ---
  Widget _buildRecommendationsList(BuildContext context, List<Movie> recommendations) {
    if (recommendations.isEmpty) {
      return Container();
    }
    return Container(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = recommendations[index];
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: InkWell(
              onTap: () {
                Navigator.pushReplacementNamed(
                  context,
                  MovieDetailPage.ROUTE_NAME,
                  arguments: movie.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
                child: CachedNetworkImage(
                  imageUrl:
                      'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: recommendations.length,
      ),
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}