
import 'dart:io';

import 'package:classnet_app/boxes.dart';
import 'package:classnet_app/course/view/all_cours.dart';
import 'package:classnet_app/errors/bloc/errors_bloc.dart';
import 'package:classnet_app/model/hive/cours.dart';
import 'package:classnet_app/model/hive/my_cours.dart';
import 'package:classnet_app/navbar/bottom_navbar.dart';
import 'package:classnet_app/translate/bloc/translate_bloc.dart';
import 'package:classnet_app/translate/bloc/translate_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:classnet_app/model/hive/hive_config.dart';
import 'package:provider/provider.dart';

import 'package:flutter/foundation.dart';



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
  var hiveBoxes = HiveConfig.getHiveBoxes();


    await Hive.openBox<Cours>(hiveBoxes);
    await Hive.openBox<My_Cours>('courbox7');


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
        return MultiProvider(
          providers: [
            Provider<ErrorsBloc>(create: (_) => ErrorsBloc()),
            Provider<TranslateBloc>(create: (_) => TranslateBloc()),
          ],
            child: BlocBuilder<TranslateBloc, TranslateState>(builder: (context, lang) {
            return MaterialApp(
              builder: (context, widget) {
                Widget error = const Text('...rendering error...');
                if (widget is Scaffold || widget is Navigator) {
                  error = Scaffold(body: Center(child: error));
                }
                ErrorWidget.builder = (errorDetails) => error;
                if (widget != null) return widget;
                throw ('widget is null');
              },
            locale:  lang.locale,
            debugShowCheckedModeBanner: false,
            title: _title,
            themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
            darkTheme: ThemeData.dark(),
            localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
                const Locale('en', ''), // English, no country code
                const Locale('fr', ''), // French, no country code
            ],
            home: NavBar(),
            );
            }),
        );
      },
    );
  }
}


