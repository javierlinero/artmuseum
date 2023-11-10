import 'package:flutter/material.dart';
import 'package:puam_app/shared/index.dart';
import 'package:puam_app/search/index.dart';

class searchResults extends StatefulWidget {
  final String query;
  const searchResults({
    super.key, required this.query,
  });

  @override
  State<searchResults> createState() => _SearchState();
}

class _SearchState extends State<searchResults> {
  double deviceHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;
  double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: 
          
          Column(
            children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text("'" + widget.query + "'", style: AppTheme.pageTitle,),
            ),
            Expanded(
              child: GridView.count(
              crossAxisCount: 3,
              children: List.generate(9, (index) {
                return Center(
                  child: Image.network(
                    'https://via.placeholder.com/150',
                    fit: BoxFit.cover),
                );
              },
                    ),
              ),
            ),
          ]),
            
    );
  }
}


