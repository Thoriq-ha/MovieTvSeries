import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movietvseries/common/constants.dart';
import 'package:movietvseries/domain/entities/tv.dart';
import 'package:movietvseries/injection.dart';
import 'package:movietvseries/presentation/bloc/tv/now_playing_tv_bloc.dart';
import 'package:movietvseries/presentation/bloc/tv/popular_tv_bloc.dart';
import 'package:movietvseries/presentation/bloc/tv/top_rated_tv_bloc.dart';
import 'package:movietvseries/presentation/pages/tv/now_playing_tv_page.dart';
import 'package:movietvseries/presentation/pages/tv/popular_tv_page.dart';
import 'package:movietvseries/presentation/pages/tv/search_tv_page.dart';
import 'package:movietvseries/presentation/pages/tv/top_rated_tv_page.dart';
import 'package:movietvseries/presentation/pages/tv/tv_detail_page.dart';
import 'package:flutter/material.dart';

class HomeTvPage extends StatelessWidget {
  static const routeName = '/tv';
  const HomeTvPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TV Page'),
        actions: [
          IconButton(
            onPressed: () {
              context.pushNamed(SearchTvPage.routeName);
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
                title: 'Now Playing',
                onTap: () => context.pushNamed(NowPlayingTvPage.routeName),
              ),
              BlocBuilder<NowPlayingTVBloc, NowPlayingTVState>(
                  bloc: locator<NowPlayingTVBloc>()..add(FetchNowPlayingTV()),
                  builder: (context, state) {
                    if (state is NowPlayingTVIsLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is NowPlayingTVIsError) {
                      return Text(state.message);
                    } else if (state is NowPlayingTVIsLoaded) {
                      return TVList(state.tvs);
                    } else {
                      return Container();
                    }
                  }),
              _buildSubHeading(
                title: 'Popular',
                onTap: () => context.pushNamed(PopularTvPage.routeName),
              ),
              BlocBuilder<PopularTVBloc, PopularTVState>(
                  bloc: locator<PopularTVBloc>()..add(FetchPopularTV()),
                  builder: (context, state) {
                    if (state is PopularTVIsLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is PopularTVIsError) {
                      return Text(state.message);
                    } else if (state is PopularTVIsLoaded) {
                      return TVList(state.tvs);
                    } else {
                      return Container();
                    }
                  }),
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () => context.pushNamed(TopRatedTvPage.routeName),
              ),
              BlocBuilder<TopRatedTVBloc, TopRatedTVState>(
                  bloc: locator<TopRatedTVBloc>()..add(FetchTopRatedTV()),
                  builder: (context, state) {
                    if (state is TopRatedTVIsLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is TopRatedTVIsError) {
                      return Text(state.message);
                    } else if (state is TopRatedTVIsLoaded) {
                      return TVList(state.tvs);
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
          style: titleLarge,
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

class TVList extends StatelessWidget {
  final List<Tv> tvs;

  const TVList(this.tvs, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 2,
            crossAxisSpacing: 3,
            childAspectRatio: 1.3),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tv = tvs[index];
          return Stack(
            children: [
              InkWell(
                onTap: () {
                  context.pushNamed(TvDetailPage.routeName, extra: tv.id);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  child: CachedNetworkImage(
                    imageUrl: '$baseImageUrl${tv.posterPath}',
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(),
                    ),
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                color: Colors.black38,
                width: double.infinity,
                height: 50,
                child: Text(
                  '${tv.name}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          );
        },
        itemCount: (tvs.length > 10) ? 10 : tvs.length,
      ),
    );
  }
}
