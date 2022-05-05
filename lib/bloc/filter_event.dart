part of 'filter_bloc.dart';

@immutable
abstract class FilterEvent extends Equatable {
}



class FilterRequestLoad extends FilterEvent {

  FilterRequestLoad();
  @override
  List<Object?> get props => [];

}

class FilterLoadTab extends FilterEvent {

  final int index;
  final FilterScreen filterScreen;

  FilterLoadTab(this.index, this.filterScreen);
  @override
  List<Object?> get props => [filterScreen, index];


}


class FilterAddKeyword extends FilterEvent {

  final FilterScreen filterScreen;
  final String type;

  FilterAddKeyword(this.filterScreen, this.type);

  @override
  List<Object?> get props => [filterScreen, type];

}

class FilterRequestSave extends FilterEvent {

  final int pageIndex;
  final FilterScreen filterScreen;
  FilterRequestSave(this.filterScreen, this.pageIndex);

  @override
  List<Object?> get props => [filterScreen, pageIndex];

}


class FilterSwitchValue extends FilterEvent {

  final FilterScreen filterScreen;
  final bool  value;
  final int itemIndex;
  final int pageIndex;

  FilterSwitchValue(this.filterScreen, this.value, this.itemIndex, this.pageIndex);

  @override
  List<Object?> get props => [filterScreen,value, itemIndex, pageIndex];

}







