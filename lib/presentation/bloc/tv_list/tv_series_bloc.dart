import 'package:ditonton/domain/usecases/get_airing_today_tv_series.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_list/tv_series_list.dart';
import 'package:ditonton/presentation/bloc/tv_list/tv_series_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AiringTodayTvSeriesBloc extends Bloc<TvSeriesListEvent, TvSeriesState> {
  final GetAiringTodayTvSeries getAiringTodayTvSeries;

  AiringTodayTvSeriesBloc(this.getAiringTodayTvSeries)
      : super(TvSeriesEmpty()) {
    on<FetchAiringTodayTvSeries>((event, emit) async {
      emit(TvSeriesLoading());
      final result = await getAiringTodayTvSeries.execute();

      result.fold(
        (failure) {
          emit(TvSeriesError(failure.message));
        },
        (data) {
          emit(TvSeriesHasData(data));
        },
      );
    });
  }
}

class PopularTvSeriesBloc extends Bloc<TvSeriesListEvent, TvSeriesState> {
  final GetPopularTvSeries getPopularTvSeries;

  PopularTvSeriesBloc(this.getPopularTvSeries) : super(TvSeriesEmpty()) {
    on<FetchPopularTvSeries>((event, emit) async {
      emit(TvSeriesLoading());
      final result = await getPopularTvSeries.execute();

      result.fold(
        (failure) {
          emit(TvSeriesError(failure.message));
        },
        (data) {
          emit(TvSeriesHasData(data));
        },
      );
    });
  }
}

class TopRatedTvSeriesBloc extends Bloc<TvSeriesListEvent, TvSeriesState> {
  final GetTopRatedTvSeries getTopRatedTvSeries;

  TopRatedTvSeriesBloc(this.getTopRatedTvSeries) : super(TvSeriesEmpty()) {
    on<FetchTopRatedTvSeries>((event, emit) async {
      emit(TvSeriesLoading());
      final result = await getTopRatedTvSeries.execute();

      result.fold(
        (failure) {
          emit(TvSeriesError(failure.message));
        },
        (data) {
          emit(TvSeriesHasData(data));
        },
      );
    });
  }
}
