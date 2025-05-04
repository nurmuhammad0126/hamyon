import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:hammyon/viewmodela/my_view_model.dart';
import 'package:provider/provider.dart';

import '../widgets/selected_container.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<MyViewModel>();

    print("\x1B[31m SETTINGS BUILD ISHLADI\x1B[0m");

    return Scaffold(
      appBar: AppBar(
        title: Text("WHEREAS RECOGNITIO"),
        actions: [
          IconButton(
            onPressed: () {
              if (AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light) {
                AdaptiveTheme.of(context).setDark();
              } else {
                AdaptiveTheme.of(context).setLight();
              }
            },
            icon: Icon(
              AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
          ),
          PopupMenuButton(
            tooltip: "Colors",
            onSelected: (int index) {
              final selectedColor = viewModel.colors[index];
              AdaptiveTheme.of(context).setTheme(
                light: ThemeData(
                  brightness: Brightness.light,
                  colorSchemeSeed: selectedColor,
                ),
                dark: ThemeData.dark().copyWith(
                  colorScheme: ColorScheme.dark(primary: selectedColor),
                ),
              );
            },

            itemBuilder: (context) {
              return List.generate(viewModel.colors.length, (index) {
                final titles = ["Orange", "Purple", "Blue", "Green", "Pink"];
                return PopupMenuItem(
                  value: index,
                  child: SelectedContainer(
                    color: viewModel.colors[index],
                    title: titles[index],
                  ),
                );
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              child: Text("😎", style: TextStyle(fontSize: 30)),
            ),

            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AdaptiveTheme.of(context).lightTheme.primaryColor,
              ),
            ),

            Center(
              child: Text(
                'Mahmudov Nurmuhammad',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: () {}, child: Text("LIKE BOSS")),
            FilledButton(onPressed: () {}, child: Text("LIKE BOSS")),

            SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Wrap(
                  spacing: 20,
                  children: [
                    Chip(label: Text("Chip va Deyl")),
                    Chip(label: Text("Chip va Deyl")),
                    Chip(label: Text("Chip va Deyl")),
                    Chip(label: Text("Chip va Deyl")),
                    Chip(label: Text("Chip va Deyl")),
                    Chip(label: Text("Chip va Deyl")),
                    Chip(label: Text("Chip va Deyl")),
                    Chip(label: Text("Chip va Deyl")),
                    Chip(label: Text("Chip va Deyl")),
                    Chip(label: Text("Chip va Deyl")),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
