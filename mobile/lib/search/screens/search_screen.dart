import 'package:flutter/material.dart';
import 'package:puam_app/shared/index.dart';
import 'package:puam_app/search/index.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  double deviceHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;
  double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;

  List<String> data = [
    'Artist',
    'Medium',
    'Time Period',
    'African American Prints',
    'Along the Edge',
    'Women Artists',
    'Abstractions',
  ];

   List<String> searchSuggestions = [];

  void onQueryChanged(String query) {
    setState(() {
      searchSuggestions = data
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

    Iterable<Widget> getSuggestions(SearchController controller) {
    final String input = controller.value.text;
    return data
        .where((data) => data.contains(input))
        .map(
          (String filteredSearch) => ListTile(
            title: Text(filteredSearch),
            trailing: IconButton(
              icon: const Icon(Icons.call_missed),
              onPressed: () {
                controller.text = filteredSearch;
                controller.selection =
                    TextSelection.collapsed(offset: controller.text.length);
              },
            ),
            onTap: () {
              controller.closeView(filteredSearch);
              print('search');
              Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => searchResults(query:filteredSearch)));
            },
          ),
        );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
            Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchAnchor(
                builder: (BuildContext context, SearchController controller) {
              return SearchBar(
                controller: controller,
                padding: const MaterialStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 16.0)),
                onTap: () {
                  controller.openView();
                },
                onChanged:onQueryChanged,
                leading: const Icon(Icons.search),
              );
            }, suggestionsBuilder:
                    (BuildContext context, SearchController controller) {
                      return getSuggestions(controller);
            }),
          ),
            buildSectionTitle('Categories'),
            buildCategoryList([
                CategoryItem(name: 'Medium', imageURL: 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5f/Chinese_-_Flask_-_Walters_491632_%28square%29.jpg/1280px-Chinese_-_Flask_-_Walters_491632_%28square%29.jpg'),
                CategoryItem(name: 'Time Period', imageURL: 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/7a/Wilton_diptych.jpg/1536px-Wilton_diptych.jpg'),
                CategoryItem(name: 'Artist', imageURL: 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/cb/Francesco_Melzi_-_Portrait_of_Leonardo.png/1024px-Francesco_Melzi_-_Portrait_of_Leonardo.png'),
            ], context), 
            buildSectionTitle('Collections'),
            buildCategoryList([
                CategoryItem(name: 'African American Prints', imageURL: 'https://puam-loris.aws.princeton.edu/loris/2009-28.jp2/full/full/0/default.jpg'),
                CategoryItem(name: 'Along the Edge: Leonora Carrington', imageURL: 'https://puam-loris.aws.princeton.edu/loris/INV09529.jp2/full/full/0/default.jpg'),
                CategoryItem(name: 'Women Artists and Abstraction', imageURL: 'https://puam-loris.aws.princeton.edu/loris/PUAMANX21_43258.jp2/full/full/0/default.jpg'),
            ], context),
            ],
          ),
        );
      }),
    );
  }
}

  class CategoryItem {
  final String name;
  final String imageURL;

  CategoryItem({required this.name, required this.imageURL});
}