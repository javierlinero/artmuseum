import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puam_app/art_of_the_day/index.dart';
import 'package:puam_app/map/index.dart';
import 'package:puam_app/scavenger_hunt/index.dart';
import 'package:puam_app/user_profile/index.dart';
import 'package:puam_app/firebase_options.dart';
import 'splash_screen/index.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
            create: (context) =>
                ArtworkScavengerHuntBloc(artworks: campusArtworks)),
        BlocProvider(create: (context) => ArtBloc(ArtworkRepository())),
        BlocProvider(create: ((context) => AuthBloc(AuthService()))),
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
