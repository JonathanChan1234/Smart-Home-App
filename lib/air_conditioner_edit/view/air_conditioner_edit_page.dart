import 'package:air_conditioner_api/air_conditioner_api.dart';
import 'package:air_conditioner_repository/air_conditioner_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_home/air_conditioner_edit/bloc/air_conditioner_edit_bloc.dart';
import 'package:smart_home/l10n/l10n.dart';

class AirConditionerEditPage extends StatelessWidget {
  const AirConditionerEditPage({
    super.key,
  });

  static Route<void> route(
    AirConditioner airConditioner,
    AirConditionerRepository airConditionerRepository,
  ) {
    return MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (context) => AirConditionerEditBloc(
          airConditioner: airConditioner,
          airConditionerRepository: airConditionerRepository,
        ),
        child: const AirConditionerEditPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AirConditionerEditBloc, AirConditionerEditState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        final localizations = AppLocalizations.of(context);
        if (state.status == AirConditionerEditStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizations.acNameChangedSuccessMessage),
            ),
          );
          Navigator.of(context).pop(true);
          return;
        }
        if (state.status == AirConditionerEditStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '''${localizations.acNameChangedFailureMessage}. ${localizations.error}: ${state.requestError}''',
              ),
            ),
          );
        }
      },
      child: const AirConditionerEditView(),
    );
  }
}

class AirConditionerEditView extends StatelessWidget {
  const AirConditionerEditView({super.key});

  @override
  Widget build(BuildContext context) {
    final status =
        context.select((AirConditionerEditBloc bloc) => bloc.state.status);
    final theme = Theme.of(context);
    final floatingActionButtonTheme = theme.floatingActionButtonTheme;
    final fabBackgroundColor = floatingActionButtonTheme.backgroundColor ??
        theme.colorScheme.secondary;
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.editAcName,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: localizations.edit,
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32)),
        ),
        backgroundColor: status.isLoadingOrSuccess
            ? fabBackgroundColor.withOpacity(0.5)
            : fabBackgroundColor,
        onPressed: status.isLoadingOrSuccess
            ? null
            : () => context
                .read<AirConditionerEditBloc>()
                .add(const AirConditionerEditFormSubmitEvent()),
        child: status.isLoadingOrSuccess
            ? const CupertinoActivityIndicator()
            : const Icon(Icons.check_rounded),
      ),
      body: const CupertinoScrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [_AirConditionerNameField()],
            ),
          ),
        ),
      ),
    );
  }
}

class _AirConditionerNameField extends StatelessWidget {
  const _AirConditionerNameField();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AirConditionerEditBloc>().state;
    final localizations = AppLocalizations.of(context);

    return TextFormField(
      key: const Key('acEdit_name_text_form'),
      initialValue: state.airConditioner.name,
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSuccess,
        labelText: localizations.acName,
      ),
      maxLength: 50,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
      ],
      onChanged: (value) {
        context
            .read<AirConditionerEditBloc>()
            .add(AirConditionerEditNameChangedEvent(name: value));
      },
    );
  }
}
