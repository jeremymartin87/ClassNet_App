
import 'dart:io';

import 'package:classnet_app/boxes.dart';
import 'package:classnet_app/course/view/all_cours.dart';
import 'package:classnet_app/model/hive/cours.dart';
import 'package:classnet_app/model/hive/my_cours.dart';
import 'package:classnet_app/navbar/bottom_navbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Box? box;
const darkModeBox = 'darkModeTutorial';
bool darkMode = false;

void main() async {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    if (kReleaseMode) exit(1);
  };
  WidgetsFlutterBinding.ensureInitialized();
  try {
  await Hive.initFlutter();
  await Hive.openBox(darkModeBox);
  Hive..registerAdapter(CoursAdapter())
  ..registerAdapter(MyCoursAdapter());
  box = await Hive.openBox<Cours>('courbox4');
  box = await Hive.openBox<My_Cours>('courbox6');
  await Hive.openBox(darkModeBox);
  await Boxes.initHive();
  } catch (e,s) {
    print('Erreur lors de l initialisation de Hive: $e');
    print(s);
    return;
    }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {


  const MyApp({super.key});

  static const String _title = 'Classnet';

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box(darkModeBox).listenable(),
      builder: (context, box, widget) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: _title,
          themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
          darkTheme: ThemeData.dark(),
          home: Scaffold(
            appBar: AppBar(title: const Text(_title)),
            body: const AllCours(),
            bottomNavigationBar: const NavBar(),
          ),
        );
      },
    );
  }
}
