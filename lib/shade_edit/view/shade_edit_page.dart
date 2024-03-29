import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shades_api/shades_api.dart';
import 'package:shades_repository/shades_repository.dart';
import 'package:smart_home/shade_edit/bloc/shade_edit_bloc.dart';

class ShadeEditPage extends StatelessWidget {
  const ShadeEditPage({super.key});

  static Route<void> route({
    required Shade shade,
    required ShadesRepository shadesRepository,
  }) {
    return MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (_) => ShadeEditBloc(
          shade: shade,
          shadesRepository: shadesRepository,
        ),
        child: const ShadeEditPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ShadeEditBloc, ShadeEditState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == ShadeEditStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Shade name changed successfully')),
          );
          Navigator.of(context).pop();
          return;
        }
        if (state.status == ShadeEditStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.requestError)),
          );
        }
      },
      child: const ShadeEditView(),
    );
  }
}

class ShadeEditView extends StatelessWidget {
  const ShadeEditView({super.key});

  @override
  Widget build(BuildContext context) {
    final status = context.select((ShadeEditBloc bloc) => bloc.state.status);
    final theme = Theme.of(context);
    final floatingActionButtonTheme = theme.floatingActionButtonTheme;
    final fabBackgroundColor = floatingActionButtonTheme.backgroundColor ??
        theme.colorScheme.secondary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Shade Name'),
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
                .read<ShadeEditBloc>()
                .add(const ShadeEditSubmittedEvent()),
        child: status.isLoadingOrSuccess
            ? const CupertinoActivityIndicator()
            : const Icon(Icons.check_rounded),
      ),
      body: CupertinoScrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: const [_ShadeNameField()],
            ),
          ),
        ),
      ),
    );
  }
}

class _ShadeNameField extends StatelessWidget {
  const _ShadeNameField();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ShadeEditBloc>().state;

    return TextFormField(
      key: const Key('shadeEdit_name_text_form'),
      initialValue: state.shade.name,
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSuccess,
        labelText: 'shade Name',
      ),
      maxLength: 50,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
      ],
      onChanged: (value) {
        context
            .read<ShadeEditBloc>()
            .add(ShadeEditNameChangedEvent(name: value));
      },
    );
  }
}
