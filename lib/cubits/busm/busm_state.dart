part of 'busm_cubit.dart';

enum BusmStatus { initial, loading, loaded, error }

class BusmState extends Equatable {
  final BusmStatus busmStatus;
  final List<Busm> kanaBusms;

  const BusmState({required this.busmStatus, required this.kanaBusms});

  @override
  List<Object> get props => [busmStatus, kanaBusms];

  factory BusmState.initial() {
    return const BusmState(busmStatus: BusmStatus.initial, kanaBusms: []);
  }

  BusmState copyWith({BusmStatus? busmStatus, List<Busm>? kanaBusms}) {
    return BusmState(
      busmStatus: busmStatus ?? this.busmStatus,
      kanaBusms: kanaBusms ?? this.kanaBusms,
    );
  }

  factory BusmState.fromJson(Map<String, dynamic> json) {
    List<Busm> kanaBusmsList = 
      (json['kanaBusms'] as List).map((busm) => Busm.fromJson(busm)).toList();

    return BusmState(
      busmStatus: BusmStatus.values.firstWhere(
        (status) => status.name.toString() == json['busmStatus'],
      ),
      kanaBusms: kanaBusmsList,
    );
  }

  Map<String, dynamic> toJson() {
    var kanaBusmList = [];
    for (var busm in kanaBusms) {
      kanaBusmList.add(busm.toJson());
    }

    return {
      'busmStatus': busmStatus.name,
      'kanaBusms':kanaBusmList,
    };
  }
}
