import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movietvseries/injection.dart';
import 'package:movietvseries/presentation/bloc/tv/popular_tv_bloc.dart';
import 'package:movietvseries/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';

class PopularTvPage extends StatelessWidget {
  static const routeName = '/popular-tv';

  const PopularTvPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Tv'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularTVBloc, PopularTVState>(
            bloc: locator<PopularTVBloc>()..add(FetchPopularTV()),
            builder: (context, state) {
              if (state is PopularTVIsLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is PopularTVIsError) {
                return Text(state.message);
              } else if (state is PopularTVIsLoaded) {
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
      ),
    );
  }
}
