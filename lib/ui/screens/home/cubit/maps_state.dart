part of 'maps_cubit.dart';

sealed class MapsState extends Equatable {
  const MapsState();
}

 class MapsInitial extends MapsState {
  final Map<PolylineId, Polyline> polylines;

  const MapsInitial({this.polylines = const {}});

  @override
  List<Object> get props => [polylines];
}

class MapsUpdated extends MapsState {
 final Map<PolylineId, Polyline> polylines;

 const MapsUpdated({this.polylines = const {}});

 @override
 List<Object> get props => [polylines];
}


