import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:billard_fr/theme_preference.dart';
import 'package:settings_ui/settings_ui.dart';

import 'db.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final settingTheme = SettingsThemeData(
        settingsListBackground: Theme.of(context).colorScheme.background
    );
    return Consumer<ThemeProvider>(
        builder: (context, ThemeProvider themeNotifier, child) {
          return Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              appBar: AppBar(title: const Text("Paramètres")),
              body: SettingsList(
                lightTheme: settingTheme,
                darkTheme: settingTheme,
                sections: [
                  SettingsSection(
                    title: Text('Apparence', style: Theme.of(context).textTheme.bodyLarge),
                    tiles: <SettingsTile>[
                      SettingsTile.switchTile(
                        activeSwitchColor: Theme.of(context).colorScheme.primary,
                          initialValue: themeNotifier.isMaterial3,
                          onToggle: (value) {
                            themeNotifier.isMaterial3 = !themeNotifier.isMaterial3;
                          },
                          title: const Text("Material 3"),
                          leading: const Icon(Icons.palette)
                      ),
                      SettingsTile.switchTile(
                        activeSwitchColor: Theme.of(context).colorScheme.primary,
                        onToggle: (value) {
                          themeNotifier.isDark = !themeNotifier.isDark;
                        },
                        initialValue: themeNotifier.isDark,
                        leading: const Icon(Icons.format_paint),
                        title: const Text('Thème sombre'),
                      ),
                    ],
                  ),
                  SettingsSection(
                      title: Text('Informations', style: Theme.of(context).textTheme.bodyLarge),
                      tiles: [
                      SettingsTile.navigation(
                          title: const Text("Base de données"),
                          description: const Text("Version: ${Db.version}"),
                          leading: const Icon(Icons.storage),
                      )
                  ])
                ],
              )
          );
        });
    }
  }