import 'package:scene_action_api/scene_action_api.dart';
import 'package:smart_home/l10n/helpers/ac_translation_helper.dart';
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
      case DeviceMainCategory.ac:
        return toAirConditionerActionDescription(
          AirConditionerAction.fromJson(action.action),
          localizations,
        );
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

  static String toAirConditionerActionDescription(
    AirConditionerAction action,
    AppLocalizations localizations,
  ) {
    final actions = <String>[
      '''${localizations.power}: ${action.power ? localizations.on : localizations.off}'''
    ];
    if (action.fanSpeed != null) {
      actions.add(
        '${localizations.acFanSpeed}: ${action.fanSpeed?.alias(localizations)}',
      );
    }
    if (action.operationMode != null) {
      actions.add(
        '''${localizations.acOperationMode}: ${action.operationMode?.alias(localizations)}''',
      );
    }

    if (action.setTemperature != null) {
      actions.add(
        '${localizations.currentTemperature}: ${action.setTemperature}°C',
      );
    }

    return actions.join(' | ');
  }
}
