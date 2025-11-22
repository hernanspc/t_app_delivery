part of 'gps_bloc.dart';

class GpsState extends Equatable {
  final bool isGpsEnabled;
  final bool isGpsPermissionGranted;
  final bool isChecking; // 👈 Nueva propiedad

  bool get isAllGranted => isGpsEnabled && isGpsPermissionGranted;

  const GpsState({
    required this.isGpsEnabled,
    required this.isGpsPermissionGranted,
    required this.isChecking,
  });

  GpsState copyWith({
    bool? isGpsEnabled,
    bool? isGpsPermissionGranted,
    bool? isChecking,
  }) => GpsState(
    isGpsEnabled: isGpsEnabled ?? this.isGpsEnabled,
    isGpsPermissionGranted:
        isGpsPermissionGranted ?? this.isGpsPermissionGranted,
    isChecking: isChecking ?? this.isChecking,
  );

  @override
  List<Object> get props => [isGpsEnabled, isGpsPermissionGranted, isChecking];

  @override
  String toString() =>
      '{ isGpsEnabled: $isGpsEnabled, isGpsPermissionGranted: $isGpsPermissionGranted isChecking: $isChecking }';
}
