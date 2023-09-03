import 'package:air_conditioner_api/air_conditioner_api.dart';
import 'package:smart_home/l10n/l10n.dart';

extension FanSpeedX on FanSpeed {
  String alias(AppLocalizations localizations) {
    switch (this) {
      case FanSpeed.quiet:
        return localizations.acFanQuiet;
      case FanSpeed.low:
        return localizations.acFanLow;
      case FanSpeed.medium:
        return localizations.acFanMedium;
      case FanSpeed.high:
        return localizations.acFanHigh;
      case FanSpeed.top:
        return localizations.acFanTop;
      case FanSpeed.auto:
        return localizations.acFanAuto;
    }
  }
}

extension OperationModeX on OperationMode {
  String alias(AppLocalizations localizations) {
    switch (this) {
      case OperationMode.fan:
        return localizations.acFanMode;
      case OperationMode.heat:
        return localizations.acHeatMode;
      case OperationMode.cool:
        return localizations.acCoolMode;
      case OperationMode.dry:
        return localizations.acDryMode;
      case OperationMode.auto:
        return localizations.acAutoMode;
    }
  }
}
