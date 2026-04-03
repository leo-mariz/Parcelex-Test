import 'package:dart_mappable/dart_mappable.dart';

part 'liveness_session_status.mapper.dart';

@MappableEnum()
enum LivenessSessionStatus {
  started,
  succeeded,
  failed,
  expired,
}
