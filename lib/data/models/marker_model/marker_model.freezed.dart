// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'marker_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MarkerModel {
  int get id;
  String get name;
  String get address;
  double get latitude;
  double get longitude;
  double get rating;
  int get pricePerHour;
  int get carsInTheParking;
  int get maxCarsInTheParking;
  int get phoneNumber;

  /// Create a copy of MarkerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MarkerModelCopyWith<MarkerModel> get copyWith =>
      _$MarkerModelCopyWithImpl<MarkerModel>(this as MarkerModel, _$identity);

  /// Serializes this MarkerModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MarkerModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.pricePerHour, pricePerHour) ||
                other.pricePerHour == pricePerHour) &&
            (identical(other.carsInTheParking, carsInTheParking) ||
                other.carsInTheParking == carsInTheParking) &&
            (identical(other.maxCarsInTheParking, maxCarsInTheParking) ||
                other.maxCarsInTheParking == maxCarsInTheParking) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      address,
      latitude,
      longitude,
      rating,
      pricePerHour,
      carsInTheParking,
      maxCarsInTheParking,
      phoneNumber);

  @override
  String toString() {
    return 'MarkerModel(id: $id, name: $name, address: $address, latitude: $latitude, longitude: $longitude, rating: $rating, pricePerHour: $pricePerHour, carsInTheParking: $carsInTheParking, maxCarsInTheParking: $maxCarsInTheParking, phoneNumber: $phoneNumber)';
  }
}

/// @nodoc
abstract mixin class $MarkerModelCopyWith<$Res> {
  factory $MarkerModelCopyWith(
          MarkerModel value, $Res Function(MarkerModel) _then) =
      _$MarkerModelCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      String name,
      String address,
      double latitude,
      double longitude,
      double rating,
      int pricePerHour,
      int carsInTheParking,
      int maxCarsInTheParking,
      int phoneNumber});
}

/// @nodoc
class _$MarkerModelCopyWithImpl<$Res> implements $MarkerModelCopyWith<$Res> {
  _$MarkerModelCopyWithImpl(this._self, this._then);

  final MarkerModel _self;
  final $Res Function(MarkerModel) _then;

  /// Create a copy of MarkerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? address = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? rating = null,
    Object? pricePerHour = null,
    Object? carsInTheParking = null,
    Object? maxCarsInTheParking = null,
    Object? phoneNumber = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _self.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _self.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _self.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      rating: null == rating
          ? _self.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      pricePerHour: null == pricePerHour
          ? _self.pricePerHour
          : pricePerHour // ignore: cast_nullable_to_non_nullable
              as int,
      carsInTheParking: null == carsInTheParking
          ? _self.carsInTheParking
          : carsInTheParking // ignore: cast_nullable_to_non_nullable
              as int,
      maxCarsInTheParking: null == maxCarsInTheParking
          ? _self.maxCarsInTheParking
          : maxCarsInTheParking // ignore: cast_nullable_to_non_nullable
              as int,
      phoneNumber: null == phoneNumber
          ? _self.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _MarkerModel implements MarkerModel {
  const _MarkerModel(
      {required this.id,
      required this.name,
      required this.address,
      required this.latitude,
      required this.longitude,
      required this.rating,
      required this.pricePerHour,
      required this.carsInTheParking,
      required this.maxCarsInTheParking,
      required this.phoneNumber});
  factory _MarkerModel.fromJson(Map<String, dynamic> json) =>
      _$MarkerModelFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String address;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final double rating;
  @override
  final int pricePerHour;
  @override
  final int carsInTheParking;
  @override
  final int maxCarsInTheParking;
  @override
  final int phoneNumber;

  /// Create a copy of MarkerModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MarkerModelCopyWith<_MarkerModel> get copyWith =>
      __$MarkerModelCopyWithImpl<_MarkerModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MarkerModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MarkerModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.pricePerHour, pricePerHour) ||
                other.pricePerHour == pricePerHour) &&
            (identical(other.carsInTheParking, carsInTheParking) ||
                other.carsInTheParking == carsInTheParking) &&
            (identical(other.maxCarsInTheParking, maxCarsInTheParking) ||
                other.maxCarsInTheParking == maxCarsInTheParking) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      address,
      latitude,
      longitude,
      rating,
      pricePerHour,
      carsInTheParking,
      maxCarsInTheParking,
      phoneNumber);

  @override
  String toString() {
    return 'MarkerModel(id: $id, name: $name, address: $address, latitude: $latitude, longitude: $longitude, rating: $rating, pricePerHour: $pricePerHour, carsInTheParking: $carsInTheParking, maxCarsInTheParking: $maxCarsInTheParking, phoneNumber: $phoneNumber)';
  }
}

/// @nodoc
abstract mixin class _$MarkerModelCopyWith<$Res>
    implements $MarkerModelCopyWith<$Res> {
  factory _$MarkerModelCopyWith(
          _MarkerModel value, $Res Function(_MarkerModel) _then) =
      __$MarkerModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      String address,
      double latitude,
      double longitude,
      double rating,
      int pricePerHour,
      int carsInTheParking,
      int maxCarsInTheParking,
      int phoneNumber});
}

/// @nodoc
class __$MarkerModelCopyWithImpl<$Res> implements _$MarkerModelCopyWith<$Res> {
  __$MarkerModelCopyWithImpl(this._self, this._then);

  final _MarkerModel _self;
  final $Res Function(_MarkerModel) _then;

  /// Create a copy of MarkerModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? address = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? rating = null,
    Object? pricePerHour = null,
    Object? carsInTheParking = null,
    Object? maxCarsInTheParking = null,
    Object? phoneNumber = null,
  }) {
    return _then(_MarkerModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _self.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _self.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _self.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      rating: null == rating
          ? _self.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      pricePerHour: null == pricePerHour
          ? _self.pricePerHour
          : pricePerHour // ignore: cast_nullable_to_non_nullable
              as int,
      carsInTheParking: null == carsInTheParking
          ? _self.carsInTheParking
          : carsInTheParking // ignore: cast_nullable_to_non_nullable
              as int,
      maxCarsInTheParking: null == maxCarsInTheParking
          ? _self.maxCarsInTheParking
          : maxCarsInTheParking // ignore: cast_nullable_to_non_nullable
              as int,
      phoneNumber: null == phoneNumber
          ? _self.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
