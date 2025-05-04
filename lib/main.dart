import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:hammyon/services/local_database.dart';
import 'package:hammyon/viewmodela/my_view_model.dart';
import 'package:hammyon/views/screens/main_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalDatabase().init();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}


class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        
        ChangeNotifierProvider(create: (ctx) => MyViewModel())
      ],
      child: AdaptiveTheme(
        initial: AdaptiveThemeMode.light,
        light: ThemeData(brightness: Brightness.light),
        dark: ThemeData(brightness: Brightness.dark),
        builder: (light, dark) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: light,
            darkTheme: dark,
            home: MainScreen(),
          );
        },
      ),
    );
  }
}
