import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puam_app/tinder_for_art/bloc/index.dart';
import 'splash_screen/index.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ArtworkBloc(),
        )
      ],
      child: MaterialApp(
        color: Colors.black,
        debugShowCheckedModeBanner: false,
        title: 'Princeton University Art Museum',
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: MySplashScreen(),
      ),
    );
  } 
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.white,
    ),
  );
}
  