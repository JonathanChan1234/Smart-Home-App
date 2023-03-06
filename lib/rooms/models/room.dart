import 'package:equatable/equatable.dart';

class Room extends Equatable {
  const Room({
    required this.name,
    required this.numberOfDevices,
    required this.floor,
    this.isFavorite = false,
  });

  final String name;
  final int numberOfDevices;
  final String floor;
  final bool isFavorite;

  @override
  List<Object> get props => [name, numberOfDevices, floor, isFavorite];
}
