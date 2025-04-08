// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'marker_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MarkerModel _$MarkerModelFromJson(Map<String, dynamic> json) => _MarkerModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      pricePerHour: (json['pricePerHour'] as num).toInt(),
      carsInTheParking: (json['carsInTheParking'] as num).toInt(),
      maxCarsInTheParking: (json['maxCarsInTheParking'] as num).toInt(),
      phoneNumber: (json['phoneNumber'] as num).toInt(),
    );

Map<String, dynamic> _$MarkerModelToJson(_MarkerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'rating': instance.rating,
      'pricePerHour': instance.pricePerHour,
      'carsInTheParking': instance.carsInTheParking,
      'maxCarsInTheParking': instance.maxCarsInTheParking,
      'phoneNumber': instance.phoneNumber,
    };
