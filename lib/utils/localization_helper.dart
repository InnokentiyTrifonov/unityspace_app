import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


/// Класс, содержащий в себе методы поддержки локализации в приложении
class LocalizationHelper {
  const LocalizationHelper();

  ///Проверка локализации на инициализацию
  ///
  ///В случае, если локализация не найдена, выдает exception
  static AppLocalizations getLocalizations(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    if (localizations == null) {
      throw Exception(
          'Localizations not found. Ensure localization is initialized properly.');
    }
    return localizations;
  }
}
