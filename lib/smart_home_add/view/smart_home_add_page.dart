import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_repository/home_repository.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:smart_home/home/bloc/home_bloc.dart';
import 'package:smart_home/l10n/l10n.dart';
import 'package:smart_home/smart_home_add/bloc/smart_home_add_bloc.dart';
import 'package:smart_home/widgets/confirm_dialog.dart';

class SmartHomeAddPage extends StatelessWidget {
  const SmartHomeAddPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (context) =>
            SmartHomeAddBloc(homeRepository: context.read<HomeRepository>()),
        child: const SmartHomeAddPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SmartHomeAddBloc, SmartHomeAddState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) async {
        final home = state.home;
        final localizations = AppLocalizations.of(context);
        if (state.status == SmartHomeAddStatus.success && home != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(localizations.addHomeSuccessMessage)),
          );
          final res = await showDialog<bool?>(
            builder: (dialogContext) => ConfirmDialog(
              content: '${localizations.enterHomeDialogContent} ${home.name}?',
              title: localizations.enterHomeDialogTitle,
              onLeftBtnClick: () => Navigator.of(dialogContext).pop(false),
              onRightBtnClick: () => Navigator.of(dialogContext).pop(true),
            ),
            context: context,
          );

          if ((res == null || !res) && context.mounted) {
            Navigator.of(context).pop();
            return;
          }

          if (context.mounted) {
            context.read<HomeBloc>().add(HomeSelectedEvent(home: home));
            return;
          }
        }
        if (state.status == SmartHomeAddStatus.failure && context.mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '''${localizations.addHomeFailureMessage}, ${state.requestError}''',
              ),
            ),
          );
        }
      },
      child: const SmartHomeAddView(),
    );
  }
}

class SmartHomeAddView extends StatelessWidget {
  const SmartHomeAddView({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(localizations.addHome)),
      body: MobileScanner(
        onDetect: (capture) {
          final barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            debugPrint('Barcode found! ${barcode.rawValue}');
            if (barcode.format != BarcodeFormat.qrCode) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(localizations.invalidQRcode)),
              );
            }
            context.read<SmartHomeAddBloc>().add(
                  SmartHomeQRcodeScannedEvent(rawData: barcode.rawValue ?? ''),
                );
          }
        },
      ),
    );
  }
}
