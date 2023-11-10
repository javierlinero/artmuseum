import 'package:flutter/material.dart';
import 'package:puam_app/search/index.dart';
import 'package:puam_app/shared/index.dart';

Widget buildCategoryList(List<CategoryItem> items, BuildContext context) {
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
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => searchResults(query: item.name,)));
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
                      padding: EdgeInsets.only(left: 5, top:10),
                      child: Text(
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
