import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puam_app/shared/index.dart';
import 'package:puam_app/search/index.dart';
import 'package:puam_app/art_of_the_day/widgets/index.dart';

class SearchDetailsPage extends StatefulWidget {
  final String artWorkID;

  const SearchDetailsPage(this.artWorkID, {super.key});

  @override
  State<SearchDetailsPage> createState() => _SearchDetailsPageState();
}

class _SearchDetailsPageState extends State<SearchDetailsPage> {
  late SearchDetailBloc _searchDetailBloc;

  double deviceHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;
  double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;

  @override
  void initState() {
    super.initState();
    _searchDetailBloc = SearchDetailBloc(SearchDetailRepo());
    _searchDetailBloc.add(FetchSearchDetailEvent(artid: widget.artWorkID));
  }

  @override
  void dispose() {
    _searchDetailBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(),
        body: BlocBuilder<SearchDetailBloc, SearchDetailState>(
          bloc: _searchDetailBloc,
          builder: (context, state) {
            if (state is SearchDetailLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is SearchDetailLoaded) {
              final searchDetail = state.searchDetails;
              return LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: constraints.maxHeight * 0.5,
                          child:
                              PaintingWidget(imageUrl: searchDetail.imageUrl),
                        ),
                        SizedBox(height: 5),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: deviceWidth(context) * 0.03,
                          ),
                          height: constraints.maxHeight * 0.05,
                          child: ArtworkNameWidget(title: searchDetail.title),
                        ),
                        SizedBox(height: 5),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: deviceWidth(context) * 0.03,
                          ),
                          height: constraints.maxHeight * 0.01,
                          child: YearWidget(year: searchDetail.year),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: deviceWidth(context) * 0.03,
                          ),
                          height: constraints.maxHeight * 0.025,
                          child: DetailsWidget(
                              materials: searchDetail.materials,
                              size: searchDetail.size),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: deviceWidth(context) * 0.03,
                          ),
                          height: constraints.maxHeight * 0.05,
                          child: ArtistWidget(artists: searchDetail.artists),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: deviceWidth(context) * 0.03,
                          ),
                          height: constraints.maxHeight * 0.2,
                          child: ArtworkDescriptionWidget(
                              description: searchDetail.description),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (state is SearchDetailError) {
              return Center(
                child: Text(state.message),
              );
            }
            return Center(child: Text('Unexpected state'));
          },
        ));
  }
}
