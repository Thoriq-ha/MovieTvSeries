import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movietvseries/injection.dart';
import 'package:movietvseries/presentation/bloc/tv/now_playing_tv_bloc.dart';
import 'package:movietvseries/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';

class NowPlayingTvPage extends StatelessWidget {
  static const routeName = '/playing-tv';

  const NowPlayingTvPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Now Playing Tv'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<NowPlayingTVBloc, NowPlayingTVState>(
            bloc: locator<NowPlayingTVBloc>()..add(FetchNowPlayingTV()),
            builder: (context, state) {
              if (state is NowPlayingTVIsLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is NowPlayingTVIsError) {
                return Text(state.message);
              } else if (state is NowPlayingTVIsLoaded) {
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
