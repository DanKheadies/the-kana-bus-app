import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:kana_bus_app/barrel.dart';

part 'busm_state.dart';

class BusmCubit extends HydratedCubit<BusmState> {
  BusmCubit() : super(BusmState.initial());

  void addBusm(Busm busm) {
    List<Busm> kanaBusmsList = state.kanaBusms.toList();
    kanaBusmsList.add(busm);
    emit(state.copyWith(kanaBusms: kanaBusmsList));
  }

  void removeBusms() {
    emit(state.copyWith(kanaBusms: []));
  }

  void removeBusm(Busm busm) {
    List<Busm> kanaBusmsList = state.kanaBusms.toList();
    kanaBusmsList.remove(busm);
    emit(state.copyWith(kanaBusms: kanaBusmsList));
  }

  @override
  BusmState? fromJson(Map<String, dynamic> json) {
    return BusmState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(BusmState state) {
    return state.toJson();
  }
}
