import 'package:freezed_annotation/freezed_annotation.dart';

part 'marker_model.freezed.dart';
part 'marker_model.g.dart';

@freezed
abstract class MarkerModel with _$MarkerModel {
    const factory MarkerModel({
        required int id,
        required String name,
        required String address,
        required double latitude,
        required double longitude,
        required double rating,
        required int pricePerHour,
        required int carsInTheParking,
        required int maxCarsInTheParking,
        required int phoneNumber,
    }) = _MarkerModel;

    factory MarkerModel.fromJson(Map<String, dynamic> json) =>
        _$MarkerModelFromJson(json);
}
