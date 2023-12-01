import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:puam_app/search/index.dart';
import 'package:puam_app/shared/index.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _searchController = TextEditingController();
  final PagingController<int, SearchArtwork> _pagingController =
      PagingController(firstPageKey: 0);
  static const _pageSize = 50;

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems =
          await context.read<SearchBloc>().searchRepo.searchArtworks(
                _searchController.text,
                limit: _pageSize,
                offset: pageKey,
              );
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: AppTheme.princetonOrange),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: AppTheme.princetonOrange),
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search, color: AppTheme.princetonOrange),
                  onPressed: () => _pagingController.refresh(),
                ),
              ),
              onSubmitted: (value) => _pagingController.refresh(),
            ),
          ),
          Expanded(
            child: PagedGridView<int, SearchArtwork>(
              pagingController: _pagingController,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 2,
              ),
              builderDelegate: PagedChildBuilderDelegate<SearchArtwork>(
                itemBuilder: (context, item, index) => _buildResult(item),
                firstPageErrorIndicatorBuilder: (context) =>
                    Text('Something went wrong'),
                noItemsFoundIndicatorBuilder: (context) =>
                    Text('No items found'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Center _buildResult(SearchArtwork item) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        child: CachedNetworkImage(
          imageUrl: '${item.imageUrl}/full/pct:10/0/default.jpg',
          fit: BoxFit.contain,
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
