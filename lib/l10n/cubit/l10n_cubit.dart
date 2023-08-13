import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:locale_repository/locale_repository.dart';

class L10nCubit extends Cubit<Locale?> {
  L10nCubit({required LocaleRepository localeRepository})
      : _localeRepository = localeRepository,
        super(
          Locale.fromSubtags(
            languageCode: localeRepository.getLanguagePreference() ?? 'und',
          ),
        );

  final LocaleRepository _localeRepository;

  Future<void> setLocale(String? languageCode) async {
    await _localeRepository.saveLanguagePreference(languageCode);
    emit(Locale.fromSubtags(languageCode: languageCode ?? 'und'));
  }
}
