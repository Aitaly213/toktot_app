part of 'maps_cubit.dart';

class MapsState extends Equatable {
 final Map<PolylineId, Polyline> polylines;

 const MapsState({
  this.polylines = const {},
 });

 MapsState copyWith({
  Map<PolylineId, Polyline>? polylines,
 }) {
  return MapsState(
   polylines: polylines ?? this.polylines,
  );
 }

 @override
 List<Object> get props => [polylines];
}
