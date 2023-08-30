import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_api/home_api.dart';
import 'package:room_api/room_api.dart';
import 'package:room_repository/room_repository.dart';
import 'package:smart_home/l10n/l10n.dart';
import 'package:smart_home/room_edit/bloc/room_edit_bloc.dart';

class RoomEditPage extends StatelessWidget {
  const RoomEditPage({super.key});

  static Route<void> route({
    required SmartHome home,
    required Room room,
    required RoomRepository roomRepository,
  }) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => BlocProvider(
        create: (context) => RoomEditBloc(
          home: home,
          roomRepository: roomRepository,
          room: room,
        ),
        child: const RoomEditPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RoomEditBloc, RoomEditState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        final localizations = AppLocalizations.of(context);
        if (state.status == RoomEditStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizations.roomNameChangedSuccessMessage),
            ),
          );
          Navigator.of(context).pop(true);
        } else if (state.status == RoomEditStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '''${localizations.roomNameChangedFailureMessage} ${localizations.error}: ${state.requestError}''',
              ),
            ),
          );
        }
      },
      child: const RoomEditView(),
    );
  }
}

class RoomEditView extends StatelessWidget {
  const RoomEditView({super.key});

  @override
  Widget build(BuildContext context) {
    final status = context.select((RoomEditBloc bloc) => bloc.state.status);
    final theme = Theme.of(context);
    final floatingActionButtonTheme = theme.floatingActionButtonTheme;
    final fabBackgroundColor = floatingActionButtonTheme.backgroundColor ??
        theme.colorScheme.secondary;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).editRoom),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Edit',
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32)),
        ),
        backgroundColor: status.isLoadingOrSuccess
            ? fabBackgroundColor.withOpacity(0.5)
            : fabBackgroundColor,
        onPressed: status.isLoadingOrSuccess
            ? null
            : () => context
                .read<RoomEditBloc>()
                .add(const RoomEditSubmittedEvent()),
        child: status.isLoadingOrSuccess
            ? const CupertinoActivityIndicator()
            : const Icon(Icons.check_rounded),
      ),
      body: const CupertinoScrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [_RoomNameField()],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoomNameField extends StatelessWidget {
  const _RoomNameField();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<RoomEditBloc>().state;
    final localizations = AppLocalizations.of(context);

    return TextFormField(
      key: const Key('roomEdit_name_text_form'),
      initialValue: state.room.name,
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSuccess,
        labelText: localizations.roomName,
      ),
      maxLength: 50,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
      ],
      onChanged: (value) {
        context.read<RoomEditBloc>().add(RoomEditNameChangedEvent(name: value));
      },
    );
  }
}
