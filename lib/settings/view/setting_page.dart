import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_home/authentication/bloc/authentication_bloc.dart';
import 'package:smart_home/home_delete/view/home_delete_page.dart';
import 'package:smart_home/l10n/l10n.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(localization.settings)),
      body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        buildWhen: (previous, current) => previous.user?.id != current.user?.id,
        builder: (context, state) {
          final user = state.user;
          if (user == null) return const Text('Invalid user');
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.account_box_rounded,
                    color: Colors.blue.shade800,
                    size: 100,
                  ),
                  Column(
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'ID: ${user.id}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ],
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    ListTile(
                      leading: const Icon(Icons.delete),
                      title: Text(localization.removeHome),
                      onTap: () =>
                          Navigator.of(context).push(HomeDeletePage.route()),
                    ),
                    ListTile(
                      leading: const Icon(Icons.password),
                      title: Text(localization.changePassword),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: Text(localization.logout),
                      onTap: () => context
                          .read<AuthenticationBloc>()
                          .add(AuthenticationLogoutRequest()),
                    )
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
