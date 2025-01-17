import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movietvseries/injection.dart';
import 'package:movietvseries/presentation/bloc/tv/top_rated_tv_bloc.dart';
import 'package:movietvseries/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';

class TopRatedTvPage extends StatelessWidget {
  static const routeName = '/top-rated-tv';

  const TopRatedTvPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated Tv'),
      ),
      body: BlocBuilder<TopRatedTVBloc, TopRatedTVState>(
          bloc: locator<TopRatedTVBloc>()..add(FetchTopRatedTV()),
          builder: (context, state) {
            if (state is TopRatedTVIsLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TopRatedTVIsError) {
              return Text(state.message);
            } else if (state is TopRatedTVIsLoaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = state.tvs[index];
                  return TvCard(tv);
                },
                itemCount: state.tvs.length,
              );
            } else {
              return Container();
            }
          }),
    );
  }
}
