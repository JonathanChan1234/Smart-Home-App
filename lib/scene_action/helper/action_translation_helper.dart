import 'package:scene_action_api/scene_action_api.dart';
import 'package:smart_home/l10n/l10n.dart';

class SceneActionTranslationHelper {
  static String toDescription(
    SceneAction action,
    AppLocalizations localizations,
  ) {
    switch (action.device.deviceMainCategory) {
      case DeviceMainCategory.light:
        return toLightActionDescription(
          LightAction.fromJson(action.action),
          localizations,
        );
      case DeviceMainCategory.shade:
        return toShadeActionDescription(
          ShadeAction.fromJson(action.action),
          localizations,
        );
      case DeviceMainCategory.unknown:
        return '';
    }
  }

  static String toLightActionDescription(
    LightAction action,
    AppLocalizations localizations,
  ) {
    final actions = <String>[];
    if (action.brightness != null) {
      actions.add('${localizations.lightBrightness}: ${action.brightness}%');
    }
    if (action.colorTemperature != null) {
      actions.add(
        '${localizations.lightColorTemperature}: ${action.colorTemperature}K',
      );
    }
    return actions.join(' | ');
  }

  static String toShadeActionDescription(
    ShadeAction action,
    AppLocalizations localizations,
  ) {
    final actions = <String>[];
    if (action.actionType != null) {
      actions.add(
        '''${localizations.shadeAction}: ${action.actionType == ShadeActionType.raise ? localizations.shadeRaiseAction : localizations.shadeLowerAction}''',
      );
    }
    if (action.level != null) {
      actions.add('${localizations.shadeLevel}: ${action.level}%');
    }
    return actions.join(' | ');
  }
}
