

import 'package:flutter/material.dart';
import 'package:puam_app/shared/index.dart';


class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  double deviceHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;
  double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;

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
                onChanged: (_) {
                  controller.openView();
                },
                leading: const Icon(Icons.search),
              );
            }, suggestionsBuilder:
                    (BuildContext context, SearchController controller) {
              return List<ListTile>.generate(5, (int index) {
                final String item = 'item $index';
                return ListTile(
                  title: Text(item),
                  onTap: () {
                    setState(() {
                      controller.closeView(item);
                    });
                  },
                );
              });
            }),
          ),
            _buildSectionTitle('Categories'),
            _buildCategoryList([
                CategoryItem(name: 'Medium', imageURL: 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5f/Chinese_-_Flask_-_Walters_491632_%28square%29.jpg/1280px-Chinese_-_Flask_-_Walters_491632_%28square%29.jpg'),
                CategoryItem(name: 'Time Period', imageURL: 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/7a/Wilton_diptych.jpg/1536px-Wilton_diptych.jpg'),
                CategoryItem(name: 'Artist', imageURL: 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/cb/Francesco_Melzi_-_Portrait_of_Leonardo.png/1024px-Francesco_Melzi_-_Portrait_of_Leonardo.png'),
            ]),
            _buildSectionTitle('Collections'),
            _buildCategoryList([
                CategoryItem(name: 'African American Prints', imageURL: 'https://puam-loris.aws.princeton.edu/loris/2009-28.jp2/full/full/0/default.jpg'),
                CategoryItem(name: 'Along the Edge: Leonora Carrington', imageURL: 'https://puam-loris.aws.princeton.edu/loris/INV09529.jp2/full/full/0/default.jpg'),
                CategoryItem(name: 'Women Artists and Abstraction', imageURL: 'https://puam-loris.aws.princeton.edu/loris/PUAMANX21_43258.jp2/full/full/0/default.jpg'),
            ]),
            ],
          ),
        );
      }),
    );
  }
}

Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(top:20, left: 10, bottom: 10),
        child: Text(title, style: TextStyle(fontSize: 18,)),
      ),
    );
  }

  Widget _buildCategoryList(List<CategoryItem> items) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row( 
        mainAxisAlignment: MainAxisAlignment.start,
        children: [ 
          Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Wrap(
            spacing: 10,
            runSpacing: 5,
            children: items.map((item) {
            return GestureDetector(
                  onTap: () { 
                  print("Tapped a Container"); 
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                        item.imageURL,
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                        },
                      ),
                  ),
                  Container(
                    width: 150,
                    child: Padding(
                      padding: EdgeInsets.only(left:5, top:15),
                      child:Text(
                                item.name,
                                style: AppTheme.categoryItem,
                              ),
                    ),
                  ),
                ]),
                );
          }).toList(),
          ),
        )],
      ),
    );
  }

  class CategoryItem {
  final String name;
  final String imageURL;

  CategoryItem({required this.name, required this.imageURL});
}