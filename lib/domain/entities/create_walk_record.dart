import 'package:pawker/data/models/create_walk_record_api_model.dart';

class CreateWalkRecord {
  final String dogId;
  final String ownerId;
  final String walkerId;
  final Duration duration;
  final double distance;
  final List<GpsCoordinate> path;
  final String location;
  final String? notes;

  CreateWalkRecord({
    required this.dogId,
    required this.ownerId,
    required this.walkerId,
    required this.duration,
    required this.distance,
    required this.path,
    required this.location,
    this.notes,
  });

  CreateWalkRecordApiModel toApiModel() {
    return CreateWalkRecordApiModel(
      dogId: dogId,
      ownerId: ownerId,
      walkerId: walkerId,
      durationSeconds: duration.inSeconds,
      distance: distance,
      path: path,
      location: location,
      notes: notes,
    );
  }
}
