import 'package:auth_api/auth_api.dart';
import 'package:auth_local_storage/auth_local_storage.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/app/app.dart';
import 'package:smart_home/bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authRepository = AuthRepository(
    authApiClient: AuthApiClient(),
    authLocalStorageApi:
        AuthLocalStorageApi(plugin: await SharedPreferences.getInstance()),
  );
  await bootstrap(
    () => App(
      authRepository: authRepository,
    ),
  );
}
