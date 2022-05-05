part of 'product_bloc.dart';

@immutable
abstract class ProductEvent extends Equatable {
 
}

class ProductLoad extends ProductEvent {

  @override
  List<Object?> get props => [
  ];
}

class ProductLoadMore extends ProductEvent {

  final List<Product> products;
  final int page;

  ProductLoadMore(this.products, this.page);
  @override
  List<Object?> get props => [products, page
  ];
}

class ProductDiscardAllEvent extends ProductEvent {

  @override
  List<Object?> get props => [
  ];
}

class ProductOpenLink extends ProductEvent {

  final String url;
  final int code;

  ProductOpenLink(this.code, this.url);

  @override
  List<Object?> get props => [
  ];
}

class ProductDiscardEvent extends ProductEvent {

  final List<Product> products;

  ProductDiscardEvent(this.products);

  @override
  List<Object?> get props => [products
  ];
}


