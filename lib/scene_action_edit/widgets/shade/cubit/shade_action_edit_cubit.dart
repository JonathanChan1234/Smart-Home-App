import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:scene_action_api/scene_action_api.dart';

part 'shade_action_edit_state.dart';

class ShadeActionEditCubit extends Cubit<ShadeActionEditState> {
  ShadeActionEditCubit({ShadeAction? action})
      : super(
          ShadeActionEditState(
            level: action?.level,
            actionType: action?.actionType,
          ),
        );

  void shadeActionEditLevelChanged(int? level) {
    emit(state.copyWith(level: () => level));
  }

  void shadeActionEditActionTypeChanged(ShadeActionType? actionType) {
    emit(state.copyWith(actionType: () => actionType));
  }
}
