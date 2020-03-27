import 'package:flutter/material.dart';

import 'package:climateorb/utils/global_translations.dart';
import 'package:climateorb/blocs/bloc_provider.dart';
import 'package:climateorb/blocs/translations_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:climateorb/screens/home.dart';
import 'package:climateorb/screens/intro.dart';
import 'package:climateorb/screens/splash.dart';

var routes = <String, WidgetBuilder>{
  "/home": (BuildContext context) => HomeScreen(),
  "/intro": (BuildContext context) => IntroScreen(),
};

void main() async {
  // Ensure the Initialization
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the translations module
  await allTranslations.init();

  // Start the application
  runApp(new ClimateOrbApp());
}

class ClimateOrbApp extends StatefulWidget {
  @override
  _ClimateOrbAppState createState() => _ClimateOrbAppState();
}
class _ClimateOrbAppState extends State<ClimateOrbApp> {
  TranslationsBloc translationsBloc;

  @override
  void initState() {
    super.initState();
    translationsBloc = TranslationsBloc();
  }

  @override
  void dispose() {
    translationsBloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TranslationsBloc>(
      bloc: translationsBloc,
      child: StreamBuilder<Locale>(
          stream: translationsBloc.currentLocale,
          initialData: allTranslations.locale,
          builder: (BuildContext context, AsyncSnapshot<Locale> snapshot) {

            return MaterialApp(
                theme: ThemeData(primaryColor: Colors.blueGrey, accentColor: Colors.blueAccent),
                debugShowCheckedModeBanner: false,
                locale: snapshot.data ?? allTranslations.locale,
                localizationsDelegates: [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],
                supportedLocales: allTranslations.supportedLocales(),
                home: SplashScreen(),
                routes: routes
            );
          }
      ),
    );
  }
}
