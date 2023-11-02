

import 'package:flutter/material.dart';
import 'package:puam_app/shared/index.dart';


class Gallery extends StatefulWidget {
  const Gallery({super.key});

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  double deviceHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;
  double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: LayoutBuilder(builder: (context, constraints) {
        return Column(
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
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 20, top: 20),
            child: Text ('Categories')),
        ),
        const Divider(
            height: 10,
            thickness: 2,
            indent: 20,
            endIndent: 20,
            color: Colors.black,
          ),      
          SizedBox(
          height: 150,
        ),
          Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 20, top: 20),
            child: Text ('Collections')),
        ),
        const Divider(
            height: 10,
            thickness: 2,
            indent: 20,
            endIndent: 20,
            color: Colors.black,
          ),
          ],
        );
      }),
    );
  }
}