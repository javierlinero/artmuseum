// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:puam_app/shared/index.dart';

class TinderForArtPage extends StatefulWidget {
  const TinderForArtPage({super.key});

  @override
  State<TinderForArtPage> createState() => _TinderForArtPageState();
}

class _TinderForArtPageState extends State<TinderForArtPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Column(
        children: [
          Text('TestPage'),
        ],
      ),
    );
  }
}
