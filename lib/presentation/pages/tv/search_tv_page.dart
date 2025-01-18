import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movietvseries/common/constants.dart';
import 'package:movietvseries/injection.dart';
import 'package:movietvseries/presentation/bloc/tv/search_tv_bloc.dart';
import 'package:movietvseries/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';

class SearchTvPage extends StatefulWidget {
  static const routeName = '/search_tv';

  const SearchTvPage({super.key});

  @override
  State<SearchTvPage> createState() => _SearchTvPageState();
}

class _SearchTvPageState extends State<SearchTvPage> {
  late TextEditingController queryC;

  @override
  void initState() {
    queryC = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    queryC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search TV'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onSubmitted: (query) {
                locator<SearchTVBloc>().add(FetchSearchTV(query: query));
              },
              decoration: InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              controller: queryC,
              textInputAction: TextInputAction.search,
            ),
            SizedBox(height: 16),
            Text(
              'Search Result',
              style: titleLarge,
            ),
            BlocBuilder<SearchTVBloc, SearchTVState>(
                bloc: locator<SearchTVBloc>()
                  ..add(FetchSearchTV(query: queryC.text)),
                builder: (context, state) {
                  if (state is SearchTVIsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is SearchTVIsError) {
                    return Text(state.message);
                  } else if (state is SearchTVIsLoaded) {
                    return Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          final tv = state.tvs[index];
                          return TvCard(tv);
                        },
                        itemCount: state.tvs.length,
                      ),
                    );
                  } else {
                    return Container();
                  }
                }),
          ],
        ),
      ),
    );
  }
}
