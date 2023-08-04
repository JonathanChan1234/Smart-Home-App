part of 'shade_action_edit_cubit.dart';

class ShadeActionEditState extends Equatable {
  const ShadeActionEditState({
    this.level,
    this.actionType,
  });

  final int? level;
  final ShadeActionType? actionType;

  bool get isValid => level != null || actionType != null;

  ShadeActionEditState copyWith({
    int? Function()? level,
    ShadeActionType? Function()? actionType,
  }) {
    return ShadeActionEditState(
      level: level != null ? level() : this.level,
      actionType: actionType != null ? actionType() : this.actionType,
    );
  }

  @override
  List<Object?> get props => [level, actionType];
}
