import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_api/home_api.dart';
import 'package:smart_home/home_delete/bloc/home_delete_bloc.dart';
import 'package:smart_home/widgets/confirm_dialog.dart';

class HomeDeleteOverview extends StatelessWidget {
  const HomeDeleteOverview({
    super.key,
    required this.homes,
  });

  final List<SmartHome> homes;

  @override
  Widget build(BuildContext context) {
    final loading = context.watch<HomeDeleteBloc>().state.requestStatus ==
        HomeDeleteRequestStatus.loading;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: ListView.builder(
              itemCount: homes.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(homes[index].name),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: loading
                      ? null
                      : () async {
                          final res = await showDialog<bool?>(
                            context: context,
                            builder: (dialogContext) => ConfirmDialog(
                              content: '''
This will remove all your permission of this home from your account.
Press "Add Home" to add the home again.
''',
                              onLeftBtnClick: () {
                                Navigator.of(dialogContext).pop(false);
                              },
                              onRightBtnClick: () {
                                Navigator.of(dialogContext).pop(true);
                              },
                              title: 'Remove Home',
                            ),
                          );
                          if (res == null || !res) return;
                          if (context.mounted) {
                            context.read<HomeDeleteBloc>().add(
                                  HomeDeleteHomeDeletedEvent(
                                    home: homes[index],
                                  ),
                                );
                          }
                        },
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
