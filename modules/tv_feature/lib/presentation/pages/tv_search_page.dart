import 'package:core/core.dart';
import 'package:core/widgets/information_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_feature/presentation/bloc/tv_search/tv_search_cubit.dart';
import 'package:tv_feature/presentation/widgets/tv_card_list.dart';

import 'tv_detail_page.dart';

class TvSearchPage extends StatelessWidget {
  static const route = '/tv/search';

  const TvSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TvSearchCubit>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onSubmitted: (query) => bloc.searchTvByQuery(query),
              decoration: const InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            const SizedBox(height: 16),
            Text(
              'Search Result',
              style: kHeading6,
            ),
            BlocBuilder<TvSearchCubit, TvSearchState>(
              builder: (context, state) {
                if (state is TvSearchLoading) {
                  return const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (state is TvSearchSuccess) {
                  final result = state.tv;

                  if (result.isEmpty) {
                    return const Expanded(
                      child: InformationWidget(
                        message:
                            'Data Tv not found, plesae search with another query',
                      ),
                    );
                  }

                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        final tv = result[index];
                        return TvCard(
                          onPress: () => Navigator.pushNamed(
                            context,
                            TvDetailPage.route,
                            arguments: tv.id,
                          ),
                          tv: tv,
                        );
                      },
                      itemCount: result.length,
                    ),
                  );
                } else if (state is TvSearchFailure) {
                  return Center(
                    key: const Key('error_message'),
                    child: InformationWidget(message: state.message),
                  );
                } else {
                  return Expanded(
                    child: Container(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
