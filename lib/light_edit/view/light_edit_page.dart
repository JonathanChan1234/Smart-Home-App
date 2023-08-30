import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lights_api/lights_api.dart';
import 'package:lights_repository/lights_repository.dart';
import 'package:smart_home/l10n/l10n.dart';
import 'package:smart_home/light_edit/bloc/light_edit_bloc.dart';

class LightEditPage extends StatelessWidget {
  const LightEditPage({
    super.key,
  });

  static Route<void> route(
    Light light,
    LightsRepository lightsRepository,
  ) {
    return MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (context) => LightEditBloc(
          light: light,
          lightsRepository: lightsRepository,
        ),
        child: const LightEditPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LightEditBloc, LightEditState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        final localizations = AppLocalizations.of(context);
        if (state.status == LightEditStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizations.lightNameChangedSuccessMessage),
            ),
          );
          Navigator.of(context).pop(true);
          return;
        }
        if (state.status == LightEditStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '''${localizations.lightNameChangedFailureMessage} ${localizations.error}: ${state.requestError}''',
              ),
            ),
          );
        }
      },
      child: const LightEditView(),
    );
  }
}

class LightEditView extends StatelessWidget {
  const LightEditView({super.key});

  @override
  Widget build(BuildContext context) {
    final status = context.select((LightEditBloc bloc) => bloc.state.status);
    final theme = Theme.of(context);
    final floatingActionButtonTheme = theme.floatingActionButtonTheme;
    final fabBackgroundColor = floatingActionButtonTheme.backgroundColor ??
        theme.colorScheme.secondary;
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.editLightName),
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
                .read<LightEditBloc>()
                .add(const LightEditSubmittedEvent()),
        child: status.isLoadingOrSuccess
            ? const CupertinoActivityIndicator()
            : const Icon(Icons.check_rounded),
      ),
      body: const CupertinoScrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [_LightNameField()],
            ),
          ),
        ),
      ),
    );
  }
}

class _LightNameField extends StatelessWidget {
  const _LightNameField();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<LightEditBloc>().state;
    final localizations = AppLocalizations.of(context);

    return TextFormField(
      key: const Key('lightEdit_name_text_form'),
      initialValue: state.light.name,
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSuccess,
        labelText: localizations.lightName,
      ),
      maxLength: 50,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
      ],
      onChanged: (value) {
        context
            .read<LightEditBloc>()
            .add(LightEditNameChangedEvent(name: value));
      },
    );
  }
}
